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
		
		public static function attributes():Object
		{
			var obj:Object = ItemData.attributes();
			Attribute.pushAttribute(obj, "type", "TeleportBox", Attribute.STRING, false);
			Attribute.pushAttribute(obj, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, false);
			Attribute.pushAttribute(obj, "bodyType", BodyType.DYNAMIC, Attribute.STRING, true, true, [BodyType.STATIC, BodyType.DYNAMIC, BodyType.KINEMATIC]);
			Attribute.pushAttribute(obj, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "height", 40, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "density", 10, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "elasticity", 0.4, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "dynamicFriction", 1, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "staticFriction", 2, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "canTeleport", true, Attribute.BOOL);
			Attribute.pushAttribute(obj, "needButtonToTeleport", true, Attribute.BOOL);
			return obj;
		}
		
		override protected function getAttributes():Object {
			return attributes();
		}
	}

}