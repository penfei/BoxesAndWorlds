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
		
		public function ButtonData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Object
		{
			var obj:Object = ItemData.attributes();
			Attribute.pushAttribute(obj, "type", "Button", Attribute.STRING, false);
			Attribute.pushAttribute(obj, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING, false);
			Attribute.pushAttribute(obj, "bodyType", BodyType.DYNAMIC, Attribute.STRING, true, true, [BodyType.STATIC, BodyType.DYNAMIC, BodyType.KINEMATIC]);
			Attribute.pushAttribute(obj, "width", 40, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "height", 40, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "density", 6, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "elasticity", 0, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "dynamicFriction", 0.3, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "staticFriction", 0.3, Attribute.NUMBER);
			return obj;
		}
		
		override protected function getAttributes():Object {
			return attributes();
		}
		
	}

}