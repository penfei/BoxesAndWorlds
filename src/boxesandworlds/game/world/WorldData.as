package boxesandworlds.game.world 
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.game.controller.Game;
	import flash.display.BitmapData;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldData 
	{
		private var _game:Game;
		private var _id:uint;
		private var _width:int;
		private var _height:int;
		private var _axis:Vec2;
		private var _rotation:Number;
		
		public function WorldData(game:Game) 
		{
			_game = game;
		}
		
		public function init(params:Object):void {
			_id = params.id;
			_rotation = 0;
			if (params.physic.WorldStructure) {
				var bitmapData:BitmapData = Core.content.library[params.physic.WorldStructure.physicsBitmap.@value].bitmapData;
				_width = bitmapData.width;
				_height = bitmapData.height;
			}else {
				_width = 800;
				_height = 800;
			}
			
			if (params.axis) _axis = params.axis;
			else _axis = new Vec2();			
		}
		
		public function get width():int {return _width;}
		public function get height():int {return _height;}
		public function get axis():Vec2 {return _axis;}
		public function get id():uint {return _id;}
		public function get rotation():Number {return _rotation;}
		public function set rotation(value:Number):void {_rotation = value;}
		
	}

}