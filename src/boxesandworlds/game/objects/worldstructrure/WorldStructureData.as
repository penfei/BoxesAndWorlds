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
			if (params.granularity) _granularity = params.granularity;
			else _granularity = Vec2.weak(8, 8);
			if (params.quality) _quality = params.quality;
			else _quality = 2;
			if (params.simplification) _simplification = params.simplification;
			else _simplification = 1.5;
			if (params.bodyType) bodyType = params.bodyType;
			else bodyType = BodyType.STATIC;
			container = game.gui.container;
			width = _physicsBitmapData.width;
			height = _physicsBitmapData.height;
		}
		
		public function get physicsBitmapData():BitmapData {return _physicsBitmapData;}
		public function get granularity():Vec2 {return _granularity;}
		public function get quality():int {return _quality;}
		public function get simplification():Number {return _simplification;}
		
	}

}