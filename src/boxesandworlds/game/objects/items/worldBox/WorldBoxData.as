package boxesandworlds.game.objects.items.worldBox 
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
	public class WorldBoxData extends ItemData
	{
		private var _childWorldId:uint;
		private var _worldBoxAreaIndentX:Number;
		private var _worldBoxAreaIndentY:Number;
		
		public function WorldBoxData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = ItemData.attributes();
			Attribute.pushAttribute(arr, "type", "WorldBox", Attribute.STRING, false);
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
			Attribute.pushAttribute(arr, "worldBoxAreaIndentX", 20, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "worldBoxAreaIndentY", 20, Attribute.NUMBER);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
		
		public function get childWorldId():uint {return _childWorldId;}
		public function set childWorldId(value:uint):void { _childWorldId = value; }
		public function get worldBoxAreaIndentX():Number {return _worldBoxAreaIndentX;}
		public function set worldBoxAreaIndentX(value:Number):void {_worldBoxAreaIndentX = value;}
		public function get worldBoxAreaIndentY():Number {return _worldBoxAreaIndentY;}
		public function set worldBoxAreaIndentY(value:Number):void { _worldBoxAreaIndentY = value; }
	}

}