package boxesandworlds.game.objects.items.worldBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectData;
	import boxesandworlds.game.objects.items.ItemData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldBoxData extends ItemData
	{
		private var _childWorldId:uint;
		
		public function WorldBoxData(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			type = "WorldBox";
			bodyType = BodyType.DYNAMIC;
			width = 40;
			height = 40;
			container = game.gui.container;
			bodyShapeType = GameObjectData.BOX_SHAPE;
			elasticity = 0.4;
			dynamicFriction = 1;
			staticFriction = 2;
			density = 10;
			super.parse(params);
		}
		
		public function get childWorldId():uint {return _childWorldId;}
		public function set childWorldId(value:uint):void {_childWorldId = value;}
	}

}