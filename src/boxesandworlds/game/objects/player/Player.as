package boxesandworlds.game.objects.player 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
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
		
		public function Player(game:Game) 
		{
			super(game);
		}
		
		public function get playerData():PlayerData {return _properties;}
		public function set playerData(value:PlayerData):void {_properties = value;}
		public function get playerView():PlayerView {return _view;}
		public function set playerView(value:PlayerView):void {_view = value;}
		
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
		}
		
		
		override public function destroy():void {
			super.destroy();
		}
		
		override public function step():void 
		{
			super.step();
			_properties.isOnEarth = isOnEarth();
			
			if (_properties.isMoveUp && _properties.isJump && canJump()) {
				if (angleRightJump() > 0.8) jumpLeft()
				else if (angleLeftJump() > 0.8) jumpRight();
				else 
					jump();
			}
			if (_properties.isMoveLeft && !_properties.isMoveRight) {
				goLeft()
			}
			if (_properties.isMoveRight && !_properties.isMoveLeft) {
				goRight();
			}
			if ((!_properties.isMoveLeft && !_properties.isMoveRight) || (_properties.isMoveLeft && _properties.isMoveRight))
				stopMotion()
			
			if (!game.data.isGameOver) _view.step();
		}
		
		private function jumpLeft():void 
		{
			body.velocity.set(new Vec2(0, 0));
			body.applyImpulse(new Vec2(_properties.jumpPower, _properties.jumpPower));
			_properties.isJump = false;
		}
		
		private function jumpRight():void 
		{
			body.velocity.set(new Vec2(0, 0));
			body.applyImpulse(new Vec2(-_properties.jumpPower, _properties.jumpPower));
			_properties.isJump = false;
		}
		
		public function jump():void {
			body.velocity.set(new Vec2(0, 0));
			body.applyImpulse(new Vec2(0.0, _properties.jumpPower));
			_properties.isJump = false;
		}
		
		public function canJump():Boolean {
			if (_properties.isOnEarth) return true;
			var list:BodyList = contacts;
			for (var i:int = 0; i < list.length; i++) {
				if(!(list.at(i).userData.obj is Player)) return true
			}
			if (_properties.isMoveLeft && (angleLeftJump() > 0.5 || angleLeftDownJump() > 0.5 || angleLeftUpJump() > 0.5))
				return true
			if (_properties.isMoveRight && (angleRightJump() > 0.5 || angleRightDownJump() > 0.5 || angleRightUpJump() > 0.5))
				return true
			return false;
		}
		
		public function goLeft():void {
			_view.showLeft();
			if (isLeftNothing) {
				var s:Number = -(_properties.speed - getVelocityCount(_properties.speed, angleLeftDown()));
				if (_properties.isOnEarth) {
					body.velocity.x = s;
				}
				else {
					body.velocity.x -= _properties.speed / 5;
					if (body.velocity.x < s) {
						body.velocity.x = s;
					}
				}
			}
		}
		
		public function goRight():void {
			_view.showRight();
			if (isRightNothing) {
				var s:Number = _properties.speed - getVelocityCount(_properties.speed, angleRightDown());
				if(_properties.isOnEarth)
					body.velocity.x = s;
				else {
					body.velocity.x += _properties.speed / 5;
					if (body.velocity.x > s) {
						body.velocity.x = s;
					}
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
	}

}