package boxesandworlds.game.objects.player 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.activator.ActivatorObject;
	import boxesandworlds.game.objects.door.Door;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.enters.gate.Gate;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.key.Key;
	import boxesandworlds.game.objects.items.worldBox.WorldBox;
	import boxesandworlds.game.world.World;
	import flash.utils.setTimeout;
	import nape.geom.AABB;
	import nape.geom.Ray;
	import nape.geom.RayResult;
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
		private var _telekinesisItem:Item;
		private var _potencialTelekinesisItem:Item;
		private var _itemArea:AABB;
		private var _potencialTeleportTarget:GameObject;
		private var _bodyListInItemArea:BodyList;
		
		private var _ray:Ray;
		private var _result:RayResult;
		
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
		public function get potencialTeleport():GameObject {return _potencialTeleportTarget;}
		public function get hasItem():Boolean {return _item != null;}
		public function get telekinesisItem():Item { return _telekinesisItem; }
		public function get hasTelekinesisItem():Boolean {return _telekinesisItem != null;}
		
		override public function init(params:Object = null):void 
		{
			data = new PlayerData(game);
			_properties = data as PlayerData;
			data.init(params);
			
			_view = new PlayerView(game, this);
			view = _view;
			super.init();
			
			_itemArea = new AABB();
		}
		
		override protected function initPhysics():void 
		{
			super.initPhysics();
			
			body.cbTypes.add(game.physics.meType);
			body.cbTypes.add(game.physics.collisionType);
			collisionGroup = 0x0100;
			collisionMask = ~0x1010;
			body.allowRotation = false;
		}
		override public function destroy():void 
		{
			super.destroy();
		}
		
		override public function step():void 
		{
			super.step();
			_properties.isOnEarth = isOnEarth();
			if (!_properties.isOnEarth) _view.showJump();
			if (_properties.isMoveUp && _properties.isJump && canJump()) jump();
			if (_properties.isMoveLeft && !_properties.isMoveRight) goLeft();
			if (_properties.isMoveRight && !_properties.isMoveLeft) goRight();
			if ((!_properties.isMoveLeft && !_properties.isMoveRight) || (_properties.isMoveLeft && _properties.isMoveRight)) stopMotion();
			applyJumper();
			_bodyListInItemArea = getBodiesInItemArea();
			searchDoor();
			searchPotencialTeleport();
			if (hasItem) {
				_item.toPlayerPosition(body.position);
			}
			
			if (!world.worldBody.contains(body.position)) {
				teleportWithEnter();
			}
			
			telekinesis();
			if (!game.data.isGameOver) _view.step();			
		}
		
		override public function addToWorld(w:World):void {
			super.addToWorld(w);
			for each(var obj:GameObject in world.objects) {
				obj.checkWorldVisible();
			}
		}
		
		override public function removeFromWorld():void {
			var w:World = world;
			super.removeFromWorld();
			for each(var obj:GameObject in w.objects) {
				obj.checkWorldVisible();
			}
		}
		
		private function applyJumper():void 
		{
			if (_properties.jumperVelocity.x != 0 || _properties.jumperVelocity.y != 0) {
				_properties.jumperVelocity.x *= 0.95;
				_properties.jumperVelocity.y *= 0.6;
				if (Math.abs(_properties.jumperVelocity.x) < 0.1) _properties.jumperVelocity.x = 0;
				if (Math.abs(_properties.jumperVelocity.y) < 0.1) _properties.jumperVelocity.y = 0;
				body.velocity.x += _properties.jumperVelocity.x;
				body.velocity.y += _properties.jumperVelocity.y;
				//trace(_properties.jumperVelocity.x, body.velocity.x);
			}
		}
		
		private function teleportWithEnter():void 
		{
			var pEnter:Enter;
			var dis:Number = int.MAX_VALUE;
			var enter:Enter;
			for each(var obj:GameObject in world.objects) {
				enter = obj as Enter;
				if (enter != null && enter.enterData.canTeleport && Vec2.distance(body.position, enter.body.position) < dis) {
					dis = Vec2.distance(body.position, enter.body.position);
					pEnter = enter;
				}
			}
			if (pEnter != null) {
				var params:Object = { teleported: this, from:pEnter };
				teleportTo(pEnter.findTarget(), params);
			} 
			//else trace("я вывалился, а куда не знаю");
		}
		
		public function jump():void 
		{
			_properties.isBeforeJump = true;
			_properties.isJump = false;
			setTimeout(jumpCallback, 60);
		}
		
		private function jumpCallback():void {
			addImpulse(Vec2.weak(0, _properties.jumpPower));
		}
		
		public function addImpulse(power:Vec2):void {
			_properties.isBeforeJump = false;
			body.velocity.set(new Vec2(0, 0));
			body.applyImpulse(power);
		}
		
		public function canJump():Boolean 
		{
			if (_properties.isOnEarth) return true;
			return false;
		}
		
		public function goLeft():void 
		{
			_properties.isRight = false;
			_view.showLeft();
			if (isLeftNothingFixture) {
				var s:Number = -(_properties.speed - getVelocityCount(_properties.speed, angleLeftDownFixture()));
				if (_properties.isOnEarth) body.velocity.x = s;
				else if(isLeftNothing){
					body.velocity.x -= _properties.speed / 5;
					if (Math.abs(body.velocity.x) > s) body.velocity.x = s;
				}
			}
		}
		
		public function goRight():void
		{
			_properties.isRight = true;
			_view.showRight();
			if (isRightNothingFixture) {
				var s:Number = _properties.speed - getVelocityCount(_properties.speed, angleRightDownFixture());
				if(_properties.isOnEarth) body.velocity.x = s;
				else if(isRightNothing){
					body.velocity.x += _properties.speed / 5;
					if (Math.abs(body.velocity.x) > s) body.velocity.x = s;
				}
			}
		}
		
		public function stopMotion():void
		{
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
				var pActivator:ActivatorObject;
				var i:Item;
				var a:ActivatorObject;
				for (var j:int = 0; j < bodyList.length; j++) {
					var d:Number = Vec2.distance(body.position, bodyList.at(j).position);
					i = bodyList.at(j).userData.obj as Item;
					a = bodyList.at(j).userData.obj as ActivatorObject;
					if (i != null && i.itemData.canAdded && d < dis) {
						dis = d;
						pItem = i;
						pActivator = null;
					}
					if (a != null&& d < dis) {
						dis = d;
						pActivator = a;
						pItem = null;
					}
				}
				addItem(pItem);
				doActivator(pActivator);
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
			teleportTo(_potencialTeleportTarget);
		}
		
		public function teleportTo(teleportTarget:GameObject, params:Object = null):void 
		{
			if (teleportTarget != null) {
				if (_item == teleportTarget) resetItem();
				body.position.set(teleportTarget.getTeleportTargetPosition(params));
				removeFromWorld();
				addToWorld(teleportTarget.world);
				if (hasItem) {
					_item.removeFromWorld();
					_item.addToWorld(teleportTarget.world);
				}
			}
		}
		
		public function resetItem():void 
		{
			if (hasItem) {
				var pos:Vec2 = new Vec2(body.position.x - ((_properties.width + _item.itemData.width + 10) / 2), body.position.y);
				if (_properties.isRight) {
					pos.x = body.position.x + ((_properties.width + _item.itemData.width + 10) / 2);
				}
				_item.removeFromPlayer(pos);
				_item = null;
			}
		}
		
		public function getBodiesInItemArea():BodyList
		{
			_itemArea.width = _properties.width + _properties.itemAreaIndentX * 2;
			_itemArea.height = _properties.height + _properties.itemAreaIndentY * 2;
			_itemArea.x = body.position.x - _properties.width / 2 - _properties.itemAreaIndentX;
			_itemArea.y = body.position.y - _properties.height / 2 - _properties.itemAreaIndentY;
			var bodyList:BodyList = game.physics.world.bodiesInAABB(_itemArea, false, true, null, bodyList);
			return bodyList;
		}
		
		public function telekinesis():void 
		{
			if (!hasTelekinesisItem){
				_potencialTelekinesisItem = game.gui.getItemUnderPoint();
			} else {
				_telekinesisItem.telekinesis();
				_ray = Ray.fromSegment(_telekinesisItem.body.position, body.position);
				_result = game.physics.world.rayCast(_ray);
				if (_result == null) removeTelekinesisItem();
				else if (_result.shape.body.userData.obj != this) removeTelekinesisItem();
			}
		}
		
		public function addTelekinesisItem():void 
		{
			if (!hasTelekinesisItem && _potencialTelekinesisItem != null) {
				_telekinesisItem = _potencialTelekinesisItem;
				_telekinesisItem.startTelekinesis();
			}
		}
		
		public function removeTelekinesisItem():void 
		{
			if (hasTelekinesisItem) {
				_telekinesisItem.stopTelekinesis();
				_telekinesisItem = null;
			}
		}
		
		private function addItem(pItem:Item):void 
		{
			if (pItem != null) {
				_item = pItem;
				_item.addToPlayer();
			}
		}
		
		private function doActivator(pActivator:ActivatorObject):void 
		{
			if (pActivator != null) {
				pActivator.activate();
			}
		}
		
		
		private function searchDoor():void 
		{
			if (hasItem && _item is Key) {
				var door:Door;
				var key:Key = _item as Key;
				for (var i:int = 0; i < _bodyListInItemArea.length; i++) {
					door = _bodyListInItemArea.at(i).userData.obj as Door;
					if (door != null && key.keyData.openedId == door.data.id) {
						door.open();
						resetItem();
						key.destroy();
						return;
					}
				}
			}
		}
		
		private function searchPotencialTeleport():void 
		{
			_potencialTeleportTarget = null;
			var dis:Number = int.MAX_VALUE;
			var teleport:GameObject;
			var potencialTeleport:GameObject;
			
			for (var i:int = 0; i < _bodyListInItemArea.length; i++) {
				teleport = _bodyListInItemArea.at(i).userData.obj as GameObject;
				if (teleport != null) {
					var d:Number = Vec2.distance(body.position, teleport.getTeleportPosition());
					var t:GameObject = teleport.findTarget();
					if (t != null && teleport.data.needButtonToTeleport && teleport != _item && d < dis) {
						dis = d;
						_potencialTeleportTarget = t;
						potencialTeleport = teleport;
					}
				}
			}
			if(potencialTeleport != null) potencialTeleport.view.showHintTeleport();
		}
	}

}