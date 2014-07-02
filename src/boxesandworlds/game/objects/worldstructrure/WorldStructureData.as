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
		private var _physicsBitmap:Bitmap;
		private var _granularity:Vec2;
		private var _quality:int;
		private var _simplification:Number;
		
		public function WorldStructureData(game:Game) 
		{
			super(game);
		}
		
		public function get physicsBitmap():Bitmap {return _physicsBitmap;}
		public function set physicsBitmap(value:Bitmap):void {_physicsBitmap = value;}
		public function get granularity():Vec2 {return _granularity;}
		public function set granularity(value:Vec2):void {_granularity = value;}
		public function get quality():int {return _quality;}
		public function set quality(value:int):void {_quality = value;}
		public function get simplification():Number {return _simplification;}
		public function set simplification(value:Number):void {_simplification = value;}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "type", "WorldStructure", Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "physicsBitmap", "", Attribute.URL, 2);
			Attribute.pushAttribute(arr, "granularity", Vec2.weak(4, 4), Attribute.VEC2);
			Attribute.pushAttribute(arr, "quality", 2, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "bodyType", BodyType.STATIC, Attribute.STRING, 0);
			Attribute.pushAttribute(arr, "simplification", 1.5, Attribute.NUMBER);
			return arr;
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			width = _physicsBitmap.width;
			height = _physicsBitmap.height;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
	}

}