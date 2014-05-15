package boxesandworlds.game.objects.enters.edgeDoor 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.objects.GameObjectData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class EdgeDoorData extends EnterData
	{			
		public function EdgeDoorData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Object
		{
			var obj:Object = EnterData.attributes();
			Attribute.pushAttribute(obj, "type", "EdgeDoor", Attribute.STRING, false);
			Attribute.pushAttribute(obj, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, false);
			Attribute.pushAttribute(obj, "bodyType", BodyType.STATIC, Attribute.STRING, false);
			Attribute.pushAttribute(obj, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "height", 40, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "density", 10, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "elasticity", 0.4, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "dynamicFriction", 1, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "staticFriction", 2, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "canTeleport", true, Attribute.BOOL);
			return obj;
		}
		
		override protected function getAttributes():Object {
			return attributes();
		}
	}

}