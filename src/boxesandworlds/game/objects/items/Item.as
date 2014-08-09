package boxesandworlds.game.objects.items 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.GameObject;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class Item extends GameObject
	{
		private var _view:ItemView;
		private var _properties:ItemData;
		
		private var _handJoint:PivotJoint;
		
		public function Item(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object = null):void {
			super.init();
			
			_handJoint = new PivotJoint(game.physics.world.world, null, Vec2.weak(), Vec2.weak());
            _handJoint.space = game.physics.world;
            _handJoint.active = false;
			_handJoint.stiff = false;
			
			if (_properties.bodyType == BodyType.STATIC) _properties.canAdded = false;
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
			if (world.worldBox != null && pEnter != null) {
				var params:Object = { teleported: this, from:pEnter };
				teleportTo(pEnter.findTarget(), params);
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
			if (body.rotation >= 0) body.rotation = uint((body.rotation + 0.7854) / 1.5708) * 1.5708;
			else body.rotation = uint((Math.abs(body.rotation) + 0.7854) / 1.5708) * -1.5708;
		}
		
		public function removeFromPlayer(position:Vec2):void 
		{
			body.velocity = Vec2.weak();
			body.shapes.at(0).filter.collisionMask = -1;
			body.allowRotation = true;
			body.position.set(position);
		}
		
		public function startTelekinesis():void 
		{
			_handJoint.body2 = body;
            _handJoint.anchor2.set(body.worldPointToLocal(game.gui.mousePoint, true));
            _handJoint.active = true;			
		}
		
		public function stopTelekinesis():void 
		{
			_handJoint.active = false;
		}
		
		public function telekinesis():void 
		{
			_handJoint.anchor1.set(game.gui.mousePoint);
			body.angularVel *= 0.6;
		}
		
		public function get itemView():ItemView {return _view;}
		public function set itemView(value:ItemView):void {_view = value;}
		public function get itemData():ItemData {return _properties;}
		public function set itemData(value:ItemData):void {_properties = value;}
		
	}

}