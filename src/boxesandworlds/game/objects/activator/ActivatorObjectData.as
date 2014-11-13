package boxesandworlds.game.objects.activator 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.objects.GameObjectData;
	import flash.display.Bitmap;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class ActivatorObjectData extends GameObjectData
	{
		public var isActivate:Boolean;
		public var callBack:Function;
		
		public function ActivatorObjectData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "type", "ActivatorObject", Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyType", BodyType.STATIC, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "height", 40, Attribute.NUMBER);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
	}

}