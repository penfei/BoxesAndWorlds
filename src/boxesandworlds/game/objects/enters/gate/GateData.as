package boxesandworlds.game.objects.enters.gate 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.objects.GameObjectData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class GateData extends EnterData
	{			
		public function GateData(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			type = "Gate";
			bodyType = BodyType.STATIC;
			width = 40;
			height = 40;
			container = game.gui.container;
			bodyShapeType = GameObjectData.BOX_SHAPE;
			elasticity = 0.4;
			dynamicFriction = 1;
			staticFriction = 2;
			density = 10;
			canTeleport = true;
			super.parse(params);
		}
	}

}