package boxesandworlds.game.controller 
{
	import boxesandworlds.data.MusicData;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.levels.tutorial.TutorialLevel;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Sah
	 */
	public class GameDataController extends Controller
	{
		private var _level:Class;
		private var _isTest:Boolean;
		private var _isGameOver:Boolean;
		private var _isPaused:Boolean;
		private var _isDestroyed:Boolean;
		
		public function GameDataController(game:Game, params:XML) 
		{
			super(game);
			
			//_level = params.level;
			if ( params.levelScript == null || params.levelScript.@scriptName == "" )
			{
				_level = Level;
			}
			else
			{
				try
				{
					_level = getDefinitionByName(params.levelScript.@scriptName) as Class;
				}
				catch (exception:Object)
				{
					_level = Level;
				}
			}
			
			_isDestroyed = true;
		}
		
		override public function init():void 
		{
			_isGameOver = false;
			_isPaused = false;
			_isDestroyed = false;
			_isTest = true;
		}
		
		override public function step():void 
		{
			
		}
		
		override public function destroy():void 
		{
			_isDestroyed = true;
		}
		
		public function gameOver():void 
		{
			_isGameOver = true;
		}
		
		public function getLevel():Level {
			return new _level(game);
		}
		
		public function get level():Class {return _level;}	
		public function get isTest():Boolean { return _isTest; }
		public function get isDestroyed():Boolean {return _isDestroyed;}
		public function get isGameOver():Boolean {return _isGameOver;}
		public function get isPaused():Boolean {return _isPaused;}
		public function set isPaused(value:Boolean):void {_isPaused = value;}
	}

}