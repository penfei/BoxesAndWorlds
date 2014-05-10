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
	import nape.dynamics.InteractionFilter;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldBox extends Item
	{
		private var _view:WorldBoxView;
		private var _properties:WorldBoxData;
		
		private var _childWorld:World;
		
		public function WorldBox(game:Game) 
		{
			super(game);
		}
		
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
		}
		
		override public function postInit():void 
		{
			super.postInit();
			
			if (_properties.childWorldId != 0) {
				for each(var world:World in game.objects.worlds) {
					if (world.data.id == _properties.childWorldId) {
						_childWorld = world;
						world.worldBox = this;
					}
				}
			}
		}
		
		override public function findTarget():GameObject
		{
			if (_properties.canTeleport) {
				var gates:Vector.<Gate> = new Vector.<Gate>();
				for each(var obj:GameObject in _childWorld.objects) {
					if (obj is Gate && (obj as Gate).data.canTeleport) {
						gates.push(obj as Gate);
					}
				}
				var dis:Number = int.MAX_VALUE;
				var pGate:Gate;
				var ray:Ray;
				var result:RayResult;
				var p:Vec2;
				for each(var gate:Gate in gates) {
					if (gate.enterData.edge == EnterData.LEFT) p = Vec2.weak( - data.width / 2 + 1, 0);
					else if (gate.enterData.edge == EnterData.RIGHT) p = Vec2.weak(data.width / 2 - 1, 0);
					else if (gate.enterData.edge == EnterData.TOP) p = Vec2.weak(0, - data.height / 2 + 1);
					else if (gate.enterData.edge == EnterData.BOTTOM) p = Vec2.weak(0, data.height / 2 - 1);
					ray = Ray.fromSegment(body.localPointToWorld(p), game.objects.me.body.position);
					result = game.physics.world.rayCast(ray, false, new InteractionFilter(1, game.objects.me.body.shapes.at(0).filter.collisionGroup));
					if (result && result.distance < dis) {
						dis = result.distance;
						pGate = gate;
					}
				}
				return pGate;
			}
			return null;
		}
		
		override public function getTeleportTargetPosition(params:Object = null):Vec2 {
			trace(params.from);
			var enter:Enter = params.from;
			var obj:GameObject = params.teleported;
			var p:Vec2;
			if (enter.enterData.edge == EnterData.LEFT) p = Vec2.weak( -data.width / 2, 0);
			else if (enter.enterData.edge == EnterData.RIGHT) p = Vec2.weak(data.width / 2, 0);
			else if (enter.enterData.edge == EnterData.TOP) p = Vec2.weak(0, -data.height / 2);
			else if (enter.enterData.edge == EnterData.BOTTOM) p = Vec2.weak(0, data.height / 2);
			return body.localPointToWorld(p);
		}
		
		override public function step():void 
		{
			super.step();
			_childWorld.rotate(body.rotation);
		}
	}

}