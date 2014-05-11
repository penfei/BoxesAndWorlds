package boxesandworlds.game.objects.player 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.enters.gate.Gate;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.Item;
	import nape.geom.AABB;
	import nape.geom.Vec2;
	import nape.phys.BodyList;
	/**
	 * ...
	 * @author Sah
	 */
	public class Player extends GameObject
	{
		private var _view:PlayerView;
		private var _properties:PlayerData;
		
		private var _item:Item;
		private var _itemArea:AABB;
		
		public function Player(game:Game) 
		{
			super(game);
		}
		
		public function get playerData():PlayerData {return _properties;}
		public function set playerData(value:PlayerData):void {_properties = value;}
		public function get playerView():PlayerView {return _view;}
		public function set playerView(value:PlayerView):void { _view = value; }
		public function get item():Item { return _item; }
		public function get itemArea():AABB {return _itemArea;}
		
		public function get hasItem():Boolean {return _item != null;}
		
		override public function init(params:Object = null):void {
			data = new PlayerData(game);
			_properties = data as PlayerData;
			data.init(params);
			
			_view = new PlayerView(game, this);
			view = _view;
			super.init();
			
			body.cbTypes.add(game.physics.meType);
			body.cbTypes.add(game.physics.movableType);
			body.cbTypes.add(game.physics.collisionType);
			body.shapes.at(0).filter.collisionGroup = 0x0100;
			body.allowRotation = false;
			
			_itemArea = new AABB();
		}
		
		
		override public function destroy():void {
			super.destroy();
		}
		
		override public function step():void 
		{
			super.step();
			_properties.isOnEarth = isOnEarth();
			
			if (_properties.isMoveUp && _properties.isJump && canJump()) jump();
			if (_properties.isMoveLeft && !_properties.isMoveRight) goLeft();
			if (_properties.isMoveRight && !_properties.isMoveLeft) goRight();
			if ((!_properties.isMoveLeft && !_properties.isMoveRight) || (_properties.isMoveLeft && _properties.isMoveRight)) stopMotion();
			
			if (hasItem) {
				_item.body.position.set(body.position);
			}
			
			if (!world.worldBody.contains(body.position)) {
				teleportWithEnter();
			}
			
			if (!game.data.isGameOver) _view.step();			
		}
		
		private function teleportWithEnter():void 
		{
			var enter:Enter;
			var dis:Number = int.MAX_VALUE;
			for each(var obj:GameObject in world.objects) {
				if (obj is Enter && (obj as Enter).enterData.canTeleport && Vec2.distance(body.position, obj.body.position) < dis) {
					dis = Vec2.distance(body.position, obj.body.position);
					enter = obj as Enter;
				}
			}
			if (world.worldBox != null && enter != null) {
				var params:Object = { teleported: this, from:enter };
				teleportTo(enter.findTarget(), params);
			} else trace("я вывалился, а куда не знаю");
		}
		
		public function jump():void {
			body.velocity.set(new Vec2(0, 0));
			body.applyImpulse(new Vec2(0.0, _properties.jumpPower));
			_properties.isJump = false;
		}
		
		public function canJump():Boolean {
			if (_properties.isOnEarth) return true;
			return false;
		}
		
		public function goLeft():void {
			_properties.isRight = false;
			_view.showLeft();
			if (isLeftNothingFixture) {
				var s:Number = -(_properties.speed - getVelocityCount(_properties.speed, angleLeftDownFixture()));
				if (_properties.isOnEarth) body.velocity.x = s;
				else if(isLeftNothing){
					body.velocity.x -= _properties.speed / 5;
					if (body.velocity.x < s) body.velocity.x = s;
				}
			}
		}
		
		public function goRight():void {
			_properties.isRight = true;
			_view.showRight();
			if (isRightNothingFixture) {
				var s:Number = _properties.speed - getVelocityCount(_properties.speed, angleRightDownFixture());
				if(_properties.isOnEarth) body.velocity.x = s;
				else if(isRightNothing){
					body.velocity.x += _properties.speed / 5;
					if (body.velocity.x > s) body.velocity.x = s;
				}
			}
		}
		
		public function stopMotion():void {
			_view.showStay();
			body.velocity.x *= 0.6;
			if (Math.abs(body.velocity.x) < 0.1) body.velocity.x = 0;
		}
		
		public function getVelocityCount(speed:Number, angle:Number):Number {
			if (angle == 1) return angle * speed;
			return angle * speed * 0.7;
		}
		
		public function itemAction():void 
		{
			if (!hasItem) {
				var bodyList:BodyList = getBodiesInItemArea();
				var dis:Number = int.MAX_VALUE;
				var pItem:Item;
				for (var i:int = 0; i < bodyList.length; i++) {
					var d:Number = Vec2.distance(body.position, bodyList.at(i).position);
					if (bodyList.at(i).userData.obj is Item && (bodyList.at(i).userData.obj as Item).itemData.canAdded && d < dis) {
						dis = d;
						pItem = bodyList.at(i).userData.obj as Item;
					}
				}
				addItem(pItem);
			} else resetItem();
		}
		
		public function itemRotate():void 
		{
			if (hasItem) {
				_item.body.rotate(_item.body.position, 1.5708);
			}
		}
		
		public function enterTeleport():void 
		{
			var bodyList:BodyList = getBodiesInItemArea();
			var dis:Number = int.MAX_VALUE;
			var pTeleport:GameObject;
			for (var i:int = 0; i < bodyList.length; i++) {
				var d:Number = Vec2.distance(body.position, bodyList.at(i).position);
				var teleport:GameObject = bodyList.at(i).userData.obj as GameObject;
				if(teleport != null){
					var t:GameObject = teleport.findTarget();
					if (t != null && teleport != _item && d < dis) {
						dis = d;
						pTeleport = t;
					}
				}
			}
			teleportTo(pTeleport);
		}
		
		public function teleportTo(teleportTarget:GameObject, params:Object = null):void 
		{
			if (teleportTarget != null) {
				if (_item == teleportTarget) resetItem();
				body.position.set(teleportTarget.getTeleportTargetPosition(params));
				world.removeGameObject(this);
				teleportTarget.world.addGameObject(this);
				if (hasItem) {
					_item.world.removeGameObject(_item);
					teleportTarget.world.addGameObject(_item);
				}
			}
		}
		
		public function resetItem():void 
		{
			if (_item != null) {
				var pos:Vec2 = new Vec2(body.position.x - (_properties.width + _item.itemData.width + 10) / 2, body.position.y);
				if (_properties.isRight) {
					pos.x = body.position.x + (_properties.width + _item.itemData.width + 10) / 2
				}
				_item.body.position.set(pos);
				_item.removeFromPlayer();
				_item = null;
			}
		}
		
		private function addItem(pItem:Item):void 
		{
			if (pItem != null) {
				_item = pItem;
				_item.addToPlayer();
			}
		}
		
		private function getBodiesInItemArea():BodyList {
			_itemArea.width = _properties.width + _properties.itemAreaIndentX * 2;
			_itemArea.height = _properties.height + _properties.itemAreaIndentY * 2;
			_itemArea.x = body.position.x - _properties.width / 2 - _properties.itemAreaIndentX;
			_itemArea.y = body.position.y - _properties.height / 2 - _properties.itemAreaIndentY;
			var bodyList:BodyList = game.physics.world.bodiesInAABB(_itemArea, false, true, null, bodyList);
			return bodyList;
		}
	}

}