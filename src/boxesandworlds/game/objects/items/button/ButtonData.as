package boxesandworlds.game.objects.items.button 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectData;
	import boxesandworlds.game.objects.items.ItemData;
	/**
	 * ...
	 * @author Sah
	 */
	public class ButtonData extends ItemData
	{
		
		public function ButtonData(game:Game) 
		{
			super(game)
		}
		
		override public function init(params:Object):void 
		{
			type = params.type;
			bodyType = params.bodyType;
			container = game.gui.container;
			bodyShapeType = GameObjectData.POINTS_SHAPE;
			if(params.shapePoints) shapePoints = params.shapePoints
			else shapePoints = game.level.getPhysic(params.ui.name);
			id = params.id;
			density = 6;
			dynamicFriction = 0.3;
			staticFriction = 0.3;
			elasticity = 0.0;
			super.init(params);
		}
		
	}

}