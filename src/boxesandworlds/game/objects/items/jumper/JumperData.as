package boxesandworlds.game.objects.items.jumper 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.objects.GameObjectData;
	import boxesandworlds.game.objects.items.ItemData;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class JumperData extends ItemData
	{		
		private var _power:Vec2;
		
		public function JumperData(game:Game) 
		{
			super(game);
		}
		
		public function get power():Vec2 {return _power;}
		public function set power(value:Vec2):void {_power = value;}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = ItemData.attributes();
			Attribute.pushAttribute(arr, "type", "Jumper", Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "power", new Vec2(0, -14000), Attribute.VEC2);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING);
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