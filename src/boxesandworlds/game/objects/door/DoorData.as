package boxesandworlds.game.objects.door 
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
	public class DoorData extends GameObjectData
	{
		private var _isOpen:Boolean;
		private var _isTemporarilyOpen:Boolean;
		
		public function DoorData(game:Game) 
		{
			super(game);
		}
		
		public function get isOpen():Boolean {return _isOpen;}
		public function set isOpen(value:Boolean):void {_isOpen = value;}
		public function get isTemporarilyOpen():Boolean {return _isTemporarilyOpen;}
		public function set isTemporarilyOpen(value:Boolean):void {_isTemporarilyOpen = value;}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "type", "Door", Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyType", BodyType.STATIC, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "isOpen", false, Attribute.BOOL);
			Attribute.pushAttribute(arr, "isTemporarilyOpen", false, Attribute.BOOL);
			Attribute.pushAttribute(arr, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "height", 80, Attribute.NUMBER);
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