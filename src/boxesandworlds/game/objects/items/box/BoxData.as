package boxesandworlds.game.objects.items.box 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectData;
	import boxesandworlds.game.objects.items.ItemData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class BoxData extends ItemData
	{
		
		public function BoxData(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			type = "Box";
			if (params.bodyType) bodyType = params.bodyType;
			else bodyType = BodyType.DYNAMIC;
			if (params.width) width = params.width;
			else width = 40;
			if (params.height) height = params.height;
			else height = 40;
			container = game.gui.container;
			bodyShapeType = GameObjectData.BOX_SHAPE;
			elasticity = 0.4;
			dynamicFriction = 1;
			staticFriction = 2;
			density = 1;
		}
	}

}