package boxesandworlds.game.objects.items.teleportBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectData;
	import boxesandworlds.game.objects.items.ItemData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class TeleportBoxData extends ItemData
	{		
		public function TeleportBoxData(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			type = "Box";
			bodyType = BodyType.DYNAMIC;
			width = 40;
			height = 40;
			container = game.gui.container;
			bodyShapeType = GameObjectData.BOX_SHAPE;
			elasticity = 0.4;
			dynamicFriction = 1;
			staticFriction = 2;
			density = 10;
			canTeleport = true;
			needButtonToTeleport = true;
			super.parse(params);
		}
	}

}