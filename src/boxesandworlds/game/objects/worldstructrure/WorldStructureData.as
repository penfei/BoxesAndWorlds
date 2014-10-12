package boxesandworlds.game.objects.worldstructrure 
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
	public class WorldStructureData extends GameObjectData
	{
		private var _isEmpty:Boolean;
		
		public function WorldStructureData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "type", "WorldStructure", Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyType", BodyType.STATIC, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BITMAP_SHAPE, Attribute.STRING);
			Attribute.pushAttribute(arr, "isEmpty", false, Attribute.BOOL);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
		
		public function get isEmpty():Boolean {return _isEmpty;}
		public function set isEmpty(value:Boolean):void {_isEmpty = value;}
	}

}