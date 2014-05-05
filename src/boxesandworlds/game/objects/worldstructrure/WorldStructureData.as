package boxesandworlds.game.objects.worldstructrure 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectData;
	import flash.display.BitmapData;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldStructureData extends GameObjectData
	{
		private var _physicsBitmapData:BitmapData;
		private var _granularity:Vec2;
		private var _quality:int;
		private var _simplification:Number;
		
		public function WorldStructureData(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			type = "WorldStructure";
			_physicsBitmapData = params.physicsBitmapData;
			_granularity = Vec2.weak(4, 4);
			_quality = 2;
			_simplification = 1.5;
			bodyType = BodyType.STATIC;
			container = game.gui.container;
			width = _physicsBitmapData.width;
			height = _physicsBitmapData.height;
			super.parse(params);
		}
		public function get physicsBitmapData():BitmapData {return _physicsBitmapData;}
		public function set physicsBitmapData(value:BitmapData):void {_physicsBitmapData = value;}
		public function get granularity():Vec2 {return _granularity;}
		public function set granularity(value:Vec2):void {_granularity = value;}
		public function get quality():int {return _quality;}
		public function set quality(value:int):void {_quality = value;}
		public function get simplification():Number {return _simplification;}
		public function set simplification(value:Number):void {_simplification = value;}
		
		
		
	}

}