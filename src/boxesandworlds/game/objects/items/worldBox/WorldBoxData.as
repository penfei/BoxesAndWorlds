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
		
		public static function attributes():Object
		{
			var obj:Object = ItemData.attributes();
			Attribute.pushAttribute(obj, "type", "WorldBox", Attribute.STRING, false);
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
			Attribute.pushAttribute(obj, "worldBoxAreaIndentX", 20, Attribute.NUMBER);
			Attribute.pushAttribute(obj, "worldBoxAreaIndentY", 20, Attribute.NUMBER);
			return obj;
		}
		
		override protected function getAttributes():Object {
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