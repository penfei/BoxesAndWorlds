package boxesandworlds.game.objects.items.button 
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
	public class ButtonData extends ItemData
	{
		private var _openedId:uint;
		
		public function ButtonData(game:Game) 
		{
			super(game);
		}
		
		public function get openedId():uint {return _openedId;}
		public function set openedId(value:uint):void {_openedId = value;}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = ItemData.attributes();
			Attribute.pushAttribute(arr, "type", "Button", Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "openedId", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyType", BodyType.STATIC, Attribute.STRING, 1, true, [BodyType.STATIC, BodyType.DYNAMIC, BodyType.KINEMATIC]);
			Attribute.pushAttribute(arr, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "height", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "density", 6, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "elasticity", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "dynamicFriction", 0.3, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "staticFriction", 0.3, Attribute.NUMBER);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}		
	}

}