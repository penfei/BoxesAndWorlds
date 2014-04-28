package boxesandworlds.game.controller 
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.game.gui.Menu;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.gui.View;
	import boxesandworlds.gui.ViewEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sah
	 */
	public class Game extends View
	{
		static public const BACK:String = "BACK";
		static public const GAME_COMPLETE:String = "GAME_COMPLETE";
		
		private var _data:GameDataController;
		private var _level:Level;
		private var _input:InputController;
		private var _physics:PhysicsController;
		private var _gui:GuiController;
		private var _objects:ObjectsController;
		private var _sound:SoundController
		
		public function Game() 
		{
			
		}
		
		public function get data():GameDataController {return _data;}
		public function get physics():PhysicsController { return _physics; }
		public function get gui():GuiController {return _gui;}
		public function get level():Level {return _level;}
		public function get input():InputController {return _input;}
		public function get objects():ObjectsController {return _objects;}
		public function get sound():SoundController { return _sound; }
		
		public function init(params:Object):void {
			_data = new GameDataController(this, params);
			_level = _data.getLevel();
			
			_sound = new SoundController(this);
		}
		
		override public function load():void {			
			_sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_sound.load();
			
			_level.addEventListener(ViewEvent.LOAD_COMPLETE, loadCompleteHandler);
			_level.load();
		}
		
		public function start():void {
			destroy();
			
			_data.init();
			
			_gui = new GuiController(this);
			_gui.init();
			
			_physics = new PhysicsController(this);
			_physics.init();
			
			_level.init();
			
			_objects = new ObjectsController(this);
			_objects.init()
			
			_input = new InputController(this);
			_input.init();
			
			_sound.init();
			
			_level.start();
			
			if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function gameOver(label:String = ""):void 
		{
			if(!_data.isGameOver){
				_data.gameOver();
				_input.destroy();
				_level.gameOver();
				trace("game over " + label);
			}
		}
		
		public function resize():void 
		{
			
		}
		
		public function back():void 
		{
			destroy();
			dispatchEvent(new Event(BACK));
		}
		
		public function complete():void 
		{
			destroy();
			dispatchEvent(new Event(GAME_COMPLETE));
		}
		
		public function destroy():void {
			if (!_data.isDestroyed) {
				_gui.destroy();
				_input.destroy();
				_sound.destroy();
				_physics.destroy();
				_level.destroy();
				_objects.destroy();
				_data.destroy();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function loadCompleteHandler(e:Event):void {
			if (_sound.isLoad && _level.isLoad) doLoadComplete();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (!_data.isPaused) {
				_data.step();
				_level.step();
				_objects.step();
				_sound.step();
				_gui.step();
				_physics.step();
			}
		}
		
	}

}