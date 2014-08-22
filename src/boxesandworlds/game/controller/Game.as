package boxesandworlds.game.controller 
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.gui.View;
	import boxesandworlds.gui.ViewEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sah
	 */
	public class Game extends View
	{
		static public const BACK:String = "BACK";
		static public const GAME_COMPLETE:String = "GAME_COMPLETE";
		static public const GAME_STARTED:String = "GAME_STARTED";
		
		private var _data:GameDataController;
		private var _level:Level;
		private var _input:InputController;
		private var _physics:PhysicsController;
		private var _gui:GuiController;
		private var _objects:ObjectsController;
		private var _sound:SoundController;
		
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
		}
		
		public function start():void {
			destroy();
			
			_data.init();
			
			_gui = new GuiController(this);
			_gui.init();
			
			_physics = new PhysicsController(this);
			_physics.init();
			
			_objects = new ObjectsController(this);
			_objects.init()
			
			_level.init();
			
			_input = new InputController(this);
			_input.init();
			
			_sound.init();
			
			_level.start();
			
			_gui.step();
			
			_objects.loadLevel(Core.data.saveObject);
			_objects.loadMe(data.params);
			
			Core.data.saveLevel();
			
			dispatchEvent(new Event(GAME_STARTED));
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
		
		override public function load():void {
			_data.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			_data.load();
		}
		
		public function loadLevel(data:Object):void {
			
		}
		
		public function saveLevel(save:Object):void {
			_objects.saveLevel(save);
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
			Core.data.saveLevel();
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
		
		private function xmlLoadCompleteHandler(e:Event):void 
		{
			_level = _data.getLevel();

			_sound = new SoundController(this);
			_sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_sound.load();

			_level.addEventListener(ViewEvent.LOAD_COMPLETE, loadCompleteHandler);
			_level.load();
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