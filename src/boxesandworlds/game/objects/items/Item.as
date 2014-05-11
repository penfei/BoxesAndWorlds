package boxesandworlds.game.objects.items 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.GameObject;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class Item extends GameObject
	{
		private var _view:ItemView;
		private var _properties:ItemData;
		
		public function Item(game:Game) 
		{
			super(game);
		}
		
		override public function step():void 
		{
			super.step();
			
			if (!world.worldBody.contains(body.position)) {
				teleportWithEnter();
			}	
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
			} else trace("я вывалился, а куда не знаю", data.type, data.id);
		}
		
		public function teleportTo(teleportTarget:GameObject, params:Object = null):void 
		{
			if (teleportTarget != null) {
				body.position.set(teleportTarget.getTeleportTargetPosition(params));
				world.removeGameObject(this);
				teleportTarget.world.addGameObject(this);
			}
		}
		
		public function addToPlayer():void 
		{
			body.shapes.at(0).filter.collisionMask = 0;
			body.allowRotation = false;
			body.angularVel = 0;
		}
		
		public function removeFromPlayer():void 
		{
			body.velocity = Vec2.weak();
			body.shapes.at(0).filter.collisionMask = -1;
			body.allowRotation = true;
		}
		
		public function get itemView():ItemView {return _view;}
		public function set itemView(value:ItemView):void {_view = value;}
		public function get itemData():ItemData {return _properties;}
		public function set itemData(value:ItemData):void {_properties = value;}
		
	}

}