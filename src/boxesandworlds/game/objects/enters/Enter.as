package boxesandworlds.game.objects.enters 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	/**
	 * ...
	 * @author Sah
	 */
	public class Enter extends GameObject
	{
		private var _view:EnterView;
		private var _properties:EnterData;
		
		public function Enter(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object = null):void {
			super.init();
		}
		
		override public function step():void 
		{
			super.step();
			
			_properties.isOpen = world != null && world.worldBox != null;
			
			if (_properties.isOpen) open();
		}
		
		public function open():void {
			body.shapes.at(0).filter.collisionMask = 0;
		}
		
		public function close():void 
		{
			body.shapes.at(0).filter.collisionMask = -1;
		}
		
		override public function findTarget():GameObject
		{
			if (_properties.isOpen) return world.worldBox;
			return null;
		}
		
		override public function getTeleportTargetPosition(params:Object = null):Vec2 {
			var p:Vec2;
			//if (enterData.edge == EnterData.LEFT) p = Vec2.weak( data.width / 2 + 10, 0);
			//else if (enterData.edge == EnterData.RIGHT) p = Vec2.weak(-data.width / 2 - 10, 0);
			//else if (enterData.edge == EnterData.TOP) p = Vec2.weak(0, data.height / 2 + 10);
			//else if (enterData.edge == EnterData.BOTTOM) p = Vec2.weak(0, -data.height / 2 - 10);
			return body.position;
		}
		
		public function get enterView():EnterView {return _view;}
		public function set enterView(value:EnterView):void {_view = value;}
		public function get enterData():EnterData {return _properties;}
		public function set enterData(value:EnterData):void {_properties = value;}
	}

}