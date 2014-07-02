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
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = EnterData.attributes();
			Attribute.pushAttribute(arr, "type", "EdgeDoor", Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyType", BodyType.STATIC, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "height", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "density", 10, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "elasticity", 0.4, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "dynamicFriction", 1, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "staticFriction", 2, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "canTeleport", true, Attribute.BOOL);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
	}

}