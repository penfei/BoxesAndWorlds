package boxesandworlds.game.objects.items.key 
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
	public class KeyData extends ItemData
	{
		private var _openedId:uint;
		
		public function KeyData(game:Game) 
		{
			super(game);
		}
		
		public function get openedId():uint {return _openedId;}
		public function set openedId(value:uint):void {_openedId = value;}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = ItemData.attributes();
			Attribute.pushAttribute(arr, "type", "Key", Attribute.STRING, false);
			Attribute.pushAttribute(arr, "openedId", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, false);
			Attribute.pushAttribute(arr, "bodyType", BodyType.DYNAMIC, Attribute.STRING);
			Attribute.pushAttribute(arr, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "height", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "density", 10, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "elasticity", 0.4, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "dynamicFriction", 1, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "staticFriction", 2, Attribute.NUMBER);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
	}
}