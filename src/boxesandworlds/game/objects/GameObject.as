package boxesandworlds.game.objects 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.world.World;
	import nape.dynamics.Arbiter;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	/**
	 * ...
	 * @author Sah
	 */
	public class GameObject
	{
		static private const ANGLE:Number = 60;
		
		private var _body:Body;
		private var _view:GameObjectView;
		private var _properties:GameObjectData;
		private var _contactList:BodyList;
		private var _rayPoint:Vec2;
		private var _ray:Ray;
		private var _result:RayResult;
		private var _teleportTarget:GameObject;
		private var _world:World;
		private var _filter:InteractionFilter;
		
		protected var game:Game;
		
		public function GameObject(game:Game) 
		{
			this.game = game;
		}
		
		public function get body():Body { return _body; }
		public function set body(value:Body):void {_body = value;}
		public function get x():Number { return _body.position.x; }
		public function get y():Number {return _body.position.y;}
		public function get view():GameObjectView {return _view;}
		public function get data():GameObjectData {return _properties;}
		public function set view(value:GameObjectView):void {_view = value;}
		public function set data(value:GameObjectData):void {_properties = value;}
		public function get target():GameObject {return _teleportTarget;}
		public function set target(value:GameObject):void { _teleportTarget = value; }
		public function get world():World {return _world;}
		public function set world(value:World):void {_world = value;}
		
		public function init(params:Object = null):void {
			initPhysics();
			initView();
			
			_rayPoint = new Vec2;
			_filter = new InteractionFilter(1, body.shapes.at(0).filter.collisionMask);
		}
		
		public function step():void {
			
		}
		
		public function destroy():void {
			destroyPhysic();
			destroyView();
			_world.removeGameObject(this);
		}
		
		public function destroyPhysic():void {
			_body.space = null;
			data.isDestroyPhysic = true;
		}
		
		public function destroyView():void {
			if(view.parent) data.container.removeChild(view);
		}
		
		
		public function set density(value:Number):void {
			for (var i:int = 0; i < _body.shapes.length; i++) {
				_body.shapes.at(i).material.density = value;
			}
		}
		
		public function set friction(value:Number):void {
			for (var i:int = 0; i < _body.shapes.length; i++) {
				_body.shapes.at(i).material.dynamicFriction = value;
			}
		}
		
		public function set elasticity(value:Number):void {
			for (var i:int = 0; i < _body.shapes.length; i++) {
				_body.shapes.at(i).material.elasticity = value;
			}
		}
		
		public function get isRightNothingFixture():Boolean {
			if (angleRightFixture() == 1 || angleRightUpFixture() == 1 || angleRightDownFixture() == 1) return false;
			return true;
		}
		
		public function get isLeftNothingFixture():Boolean {
			if (angleLeftFixture() == 1 || angleLeftUpFixture() == 1 || angleLeftDownFixture() == 1) return false;
			return true;
		}
		
		public function get isRightNothing():Boolean {
			if (angleRight() == 1 || angleRightUp() == 1 || angleRightDown() == 1) return false;
			return true;
		}
		
		public function get isLeftNothing():Boolean {
			if (angleLeft() == 1 || angleLeftUp() == 1 || angleLeftDown() == 1) return false;
			return true;
		}
		
		public function get contacts():BodyList {
			_contactList = new BodyList;
			body.arbiters.foreach(function (arb:Arbiter):void {
			   if(!_contactList.has(arb.body1)) _contactList.add(arb.body1);
			   if(!_contactList.has(arb.body2)) _contactList.add(arb.body2);
			});
			return _contactList;
		}
		
		protected function initPhysics():void {
			_body = new Body(_properties.bodyType, _properties.start);
			
			_body.userData.obj = this;
			_body.velocity.set(_properties.startLV);
			var m:Material = new Material(_properties.elasticity, _properties.dynamicFriction, _properties.staticFriction, _properties.density);
			var shape:Shape;
			if (_properties.bodyShapeType == GameObjectData.BOX_SHAPE) {
				shape = new Polygon(Polygon.box(_properties.width, _properties.height), m);
			}
			if (_properties.bodyShapeType == GameObjectData.POINTS_SHAPE) {
				shape = new Polygon(_properties.shapePoints, m);
			}
			_body.shapes.add(shape);
			_body.rotation = _properties.startAngle;
			var p:Vec2 = _body.position.copy();
			_body.align();
			if (_body.isStatic()) _body.position.set(p);
			_body.space = game.physics.world;
			
			_properties.mass = _body.mass;
		}
		
		protected function initView():void {
			if (_view == null) {
				_view = new GameObjectView(game, this);
			}
			_view.init();
			_view.x = _body.position.x;
			_view.y = _body.position.y;
			
			_properties.container.addChild(_view);
		}
		
		public function postInit():void 
		{
			if (_properties.teleportId != 0) {
				for each(var world:World in game.objects.worlds) {
					for each(var obj:GameObject in world.objects) {
						if (obj.data.id == _properties.teleportId) {
							_teleportTarget = obj;
						}
					}
				}
			}
		}
		
		public function isOnEarth():Boolean {
			_rayPoint.x = body.position.x;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			_ray = Ray.fromSegment(body.position, _rayPoint);
			_result = game.physics.world.rayCast(_ray, false, _filter);
			if (_result != null && !rayCastSettings(_result.shape)) return true;
			_rayPoint.x = body.position.x + _properties.width / 2 - _properties.offsetX;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			_ray = Ray.fromSegment(body.position, _rayPoint);
			_result = game.physics.world.rayCast(_ray, false, _filter);
			if (_result != null && !rayCastSettings(_result.shape) && angleRightDown() != 1) return true;
			_rayPoint.x = body.position.x - _properties.width / 2 + _properties.offsetX;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			_ray = Ray.fromSegment(body.position, _rayPoint);
			_result = game.physics.world.rayCast(_ray, false, _filter);
			if (_result != null && !rayCastSettings(_result.shape) && angleLeftDown() != 1) return true;
			return false;
		}
		
		public function angleLeftDown():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleLeft():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX;
			_rayPoint.y = body.position.y;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleLeftDownFixture():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			
			return getAngleRayCastFixture(body.position, _rayPoint);
		}
		
		public function angleLeftUpFixture():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX;
			_rayPoint.y = body.position.y - _properties.height / 2 - _properties.offsetY;
			
			return getAngleRayCastFixture(body.position, _rayPoint);
		}
		
		public function angleLeftUp():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX;
			_rayPoint.y = body.position.y - _properties.height / 2 - _properties.offsetY;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleLeftFixture():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX;
			_rayPoint.y = body.position.y;
			
			return getAngleRayCastFixture(body.position, _rayPoint);
		}
		
		public function angleLeftJump():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX - 3;
			_rayPoint.y = body.position.y;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleLeftDownJump():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX - 3;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY + 3
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleLeftUpJump():Number {
			_rayPoint.x = body.position.x - _properties.width / 2 - _properties.offsetX - 3;
			_rayPoint.y = body.position.y - _properties.height / 2 - _properties.offsetY - 3;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleRightDown():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleRight():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX;
			_rayPoint.y = body.position.y;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleRightDownFixture():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			
			return getAngleRayCastFixture(body.position, _rayPoint);
		}
		
		public function angleRightUpFixture():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX;
			_rayPoint.y = body.position.y - _properties.height / 2 - _properties.offsetY;
			
			return getAngleRayCastFixture(body.position, _rayPoint);
		}
		
		public function angleRightUp():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX;
			_rayPoint.y = body.position.y - _properties.height / 2 - _properties.offsetY;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleRightFixture():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX;
			_rayPoint.y = body.position.y;
			
			return getAngleRayCastFixture(body.position, _rayPoint);
		}
		
		public function angleRightJump():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX + 3;
			_rayPoint.y = body.position.y;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleRightDownJump():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX + 3;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY + 3;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleRightUpJump():Number {
			_rayPoint.x = body.position.x + _properties.width / 2 + _properties.offsetX + 3;
			_rayPoint.y = body.position.y - _properties.height / 2 - _properties.offsetY - 3;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleDown():Number {
			_rayPoint.x = body.position.x;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function angleDownJump():Number {
			_rayPoint.x = body.position.x;
			_rayPoint.y = body.position.y + _properties.height / 2 + _properties.offsetY + 10;
			
			return getAngleRayCast(body.position, _rayPoint);
		}
		
		public function findTarget():GameObject { 
			if (_properties.canTeleport) return _teleportTarget;
			return null;
		}
		
		public function getTeleportTargetPosition(params:Object = null):Vec2 { 
			return _body.position;
		}
		
		private function getAngleRayCast(original:Vec2, vector:Vec2):Number {
			var angle:Number = 0;
			_ray = Ray.fromSegment(original, vector);
			_result = game.physics.world.rayCast(_ray, false, _filter);
			if (_result) {
				angle = Math.abs(_result.normal.x * (90 / ANGLE));
				if (rayCastSettings(_result.shape))
					return 0
			}
			if (angle > 1) angle = 1;
			return angle;
		}
		
		private function getAngleRayCastFixture(original:Vec2, vector:Vec2):Number {
			var angle:Number = 0;
			_ray = Ray.fromSegment(original, vector);
			_result = game.physics.world.rayCast(_ray, false, _filter);
			if (_result) {
				angle = Math.abs(_result.normal.x * (90 / ANGLE));
				if (_result.shape.body.isDynamic()) return 0;
				if (rayCastSettings(_result.shape))
					return 0
			}
			if (angle > 1) angle = 1;
			return angle;
		}
		
		protected function rayCastSettings(shape:Shape):Boolean {
			if (!((shape.filter.collisionGroup & _body.shapes.at(0).filter.collisionMask) && (_body.shapes.at(0).filter.collisionGroup & shape.filter.collisionMask))) return true;
			if (shape.sensorEnabled) return true;
			return false
		}
	}

}