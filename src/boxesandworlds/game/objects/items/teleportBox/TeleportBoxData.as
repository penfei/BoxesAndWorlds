package boxesandworlds.game.objects.items.teleportBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
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
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = ItemData.attributes();
			Attribute.pushAttribute(arr, "type", "TeleportBox", Attribute.STRING, false);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, false);
			Attribute.pushAttribute(arr, "bodyType", BodyType.DYNAMIC, Attribute.STRING, true, true, [BodyType.STATIC, BodyType.DYNAMIC, BodyType.KINEMATIC]);
			Attribute.pushAttribute(arr, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "height", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "density", 10, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "elasticity", 0.4, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "dynamicFriction", 1, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "staticFriction", 2, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "canTeleport", true, Attribute.BOOL);
			Attribute.pushAttribute(arr, "needButtonToTeleport", true, Attribute.BOOL);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
	}

}