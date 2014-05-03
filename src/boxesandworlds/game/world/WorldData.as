package boxesandworlds.game.world 
{
	import boxesandworlds.game.controller.Game;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldData 
	{
		private var _game:Game;
		private var _width:int;
		private var _height:int;
		private var _axis:Vec2;
		
		public function WorldData(game:Game) 
		{
			_game = game;
		}
		
		public function init(params:Object):void {
			if (params.width) _width = params.width;
			else _width = 800;
			if (params.height) _height = params.height;
			else _height = 800;
			if (params.axis) _axis = params.axis;
			else _axis = new Vec2();			
		}
		
		public function get width():int {return _width;}
		public function get height():int {return _height;}
		public function get axis():Vec2 {return _axis;}
		
	}

}