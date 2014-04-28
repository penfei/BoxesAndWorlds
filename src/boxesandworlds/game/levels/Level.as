package boxesandworlds.game.levels 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.LevelParser;
	import boxesandworlds.gui.View;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class Level extends View
	{
		private var _view:LevelView;
		private var _data:LevelData;
		private var _parser:LevelParser;
		private var _isLoad:Boolean;
		
		protected var game:Game;
		
		public function Level(game:Game) 
		{
			this.game = game;
			_parser = new LevelParser(game);
			_isLoad = false;
		}
		
		public function get view():LevelView {return _view;}
		public function set view(value:LevelView):void {_view = value;}
		public function get data():LevelData {return _data;}
		public function set data(value:LevelData):void {_data = value;}
		public function get isLoad():Boolean {return _isLoad;}
		
		public function init():void {
			_parser.parse();
		}
		
		public function step():void {
			
		}
		
		public function destroy():void {
			
		}
		
		override public function load():void {
			_isLoad = true;
			doLoadComplete();
		}
		
		public function getPhysic(name:String):Array {
			var points:Array = new Array
			return points;
		}
		
		public function restart():void {
			if (contains(view)) removeChild(view);
		}
		
		public function start():void 
		{
			
		}
		
		public function gameOver():void 
		{
			
		}
	}

}