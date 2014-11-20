package boxesandworlds.game.objects.items.worldBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.objects.enters.gate.Gate;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.ItemData;
	import boxesandworlds.game.world.World;
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.dynamics.InteractionFilter;
	import nape.geom.AABB;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	import nape.phys.BodyList;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldBox extends Item
	{
		private var _view:WorldBoxView;
		private var _properties:WorldBoxData;
		
		private var _childWorld:World;
		private var _worldBoxArea:AABB;
		private var _connectedWorldBox:WorldBox;
		private var _connectedEdge:String;
		private var _ray:Ray;
		private var _result:RayResult;
		private var _connectedEdgePoint:Vec2;
		private var _teleportPoint:Vec2;
		
		public function WorldBox(game:Game) 
		{
			super(game);
		}
		
		public function get childWorld():World {return _childWorld;}
		public function get connectedEdge():String {return _connectedEdge;}
		public function get connectedEdgePoint():Vec2 {return _connectedEdgePoint;}
		
		override public function init(params:Object = null):void {
			data = new WorldBoxData(game);
			itemData = data as ItemData; 
			_properties = data as WorldBoxData;
			_properties.init(params);
			
			_view = new WorldBoxView(game, this);
			itemView = _view;
			view = _view;
			
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
			collisionGroup = 0x0010;
			_worldBoxArea = new AABB();
		}
		
		override public function postInit():void 
		{
			super.postInit();
			
			if (_properties.childWorldId != 0) {
				for each(var world:World in game.objects.worlds) {
					if (world.data.id == _properties.childWorldId) {
						_childWorld = world;
						world.worldBox = this;
						_view.postInit();
					}
				}
			}
		}
		
		override public function findTarget():GameObject
		{
			if (_properties.canTeleport) {
				var gates:Vector.<Gate> = new Vector.<Gate>();
				var pGate:Gate;
				for each(var obj:GameObject in _childWorld.objects) {
					pGate = obj as Gate;
					if (pGate != null && pGate.enterData.canTeleport) gates.push(pGate);
				}
				var dis:Number = int.MAX_VALUE;
				var ray:Ray;
				var result:RayResult;
				var p:Vec2;
				var d:Number;
				pGate = null;
				_teleportPoint = null;
				for each(var gate:Gate in gates) {
					p = body.localPointToWorld(getPointByEdge(gate.enterData.edge));
					d =  Vec2.distance(p, game.objects.me.body.position);
					if(d < dis){
						dis = d;
						pGate = gate;
						_teleportPoint = p;
					}
				}
				return pGate;
			}
			return null;
		}
		
		override public function getTeleportPosition():Vec2 {
			if (_teleportPoint != null) return _teleportPoint;
			return Vec2.weak();
		}
		
		override public function getTeleportTargetPosition(params:Object = null):Vec2 {
			var enter:Enter = params.from;
			var p:Vec2 = getPointByEdge(enter.enterData.edge);
			return body.localPointToWorld(p);
		}
		
		override public function step():void 
		{
			super.step();
			_childWorld.rotate(body.rotation);
			
			_connectedWorldBox = null;
			if (this == game.objects.me.item) searchWorldBoxes();
		}
		
		override public function addToPlayer():void 
		{
			super.addToPlayer();
			
			for (var i:uint = 0; i < body.constraints.length; i++) {
				body.constraints.at(i).space = null;
			}
			
			_childWorld.clearConnectedWorlds();
		}
		
		override public function removeFromPlayer(pos:Vec2):void 
		{	
			if (_connectedWorldBox != null) {
				//trace(_connectedEdge, _connectedWorldBox.connectedEdge, _connectedEdgePoint, _connectedWorldBox.connectedEdgePoint);
				var p:Vec2 = _connectedWorldBox.connectedEdgePoint.copy();
				body.position.set(_connectedWorldBox.body.localPointToWorld(p));
				var pivotJoint:PivotJoint = new PivotJoint(body, _connectedWorldBox.body, _connectedEdgePoint, p);
				pivotJoint.space = game.physics.world;
				
				_childWorld.connectWorldToEdge(_connectedWorldBox.childWorld, _connectedEdge);
				_connectedWorldBox.childWorld.connectWorldToEdge(_childWorld, _connectedWorldBox.connectedEdge);
			} else body.position.setxy(pos.x + itemData.addedOffset.x, pos.y + itemData.addedOffset.y);
			
			body.velocity = Vec2.weak();
			collisionMask = -1;
			body.allowRotation = true;
		}
		
		public function findEdge(worldBox:WorldBox):void {
			_ray = Ray.fromSegment(body.position, worldBox.body.position);
			_result = game.physics.world.rayCast(_ray, true);
			if(_result != null){
				var localRayPoint:Vec2 = body.worldPointToLocal(_ray.at(_result.distance));
				
				var dis:Number = int.MAX_VALUE;
				if (Math.abs(localRayPoint.x - data.width / 2) < dis) {
					dis = Math.abs(localRayPoint.x - data.width / 2);
					_connectedEdge = EnterData.RIGHT;
					_connectedEdgePoint = Vec2.weak(data.width / 2);
				}
				if (Math.abs(-localRayPoint.x - data.width / 2) < dis) {
					dis = Math.abs(-localRayPoint.x - data.width / 2);
					_connectedEdge = EnterData.LEFT;
					_connectedEdgePoint = Vec2.weak(-data.width / 2);
				}
				if (Math.abs(localRayPoint.y - data.height / 2) < dis) {
					dis = Math.abs(localRayPoint.y - data.width / 2);
					_connectedEdge = EnterData.BOTTOM;
					_connectedEdgePoint = Vec2.weak(0, data.height / 2);
				}
				if (Math.abs(-localRayPoint.y - data.height / 2) < dis) {
					dis = Math.abs(-localRayPoint.y - data.width / 2);
					_connectedEdge = EnterData.TOP;
					_connectedEdgePoint = Vec2.weak(0, -data.height / 2);
				}
				_view.showConnectedEdge();
			}
		}
		
		public function getPointByEdge(edge:String):Vec2 {
			if (edge == EnterData.LEFT) return Vec2.weak( -data.width / 2, 0);
			if (edge == EnterData.RIGHT) return Vec2.weak( data.width / 2, 0);
			if (edge == EnterData.TOP) return Vec2.weak( 0, -data.height / 2);
			if (edge == EnterData.BOTTOM) return Vec2.weak( 0, data.height / 2);
			return Vec2.weak();
		}
		
		private function searchWorldBoxes():void 
		{
			var bodyList:BodyList = game.objects.me.getBodiesInItemArea();
			var dis:Number = int.MAX_VALUE;
			_connectedEdge = "";
			_connectedEdgePoint = null;
			
			for (var i:int = 0; i < bodyList.length; i++) {
				var d:Number = Vec2.distance(body.position, bodyList.at(i).position);
				var box:WorldBox = bodyList.at(i).userData.obj as WorldBox;
				if (box != null && box != this && d < dis) {
					dis = d;
					_connectedWorldBox = box;
				}
			}
			if (_connectedWorldBox != null) {
				findEdge(_connectedWorldBox);
				_connectedWorldBox.findEdge(this);
			} 
		}
	}

}