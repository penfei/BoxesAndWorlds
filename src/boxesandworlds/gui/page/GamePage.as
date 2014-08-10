package boxesandworlds.gui.page {
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.DataManager;
	import boxesandworlds.controller.UIManager;
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.controller.GameDataController;
	import boxesandworlds.game.levels.tutorial.TutorialLevel;
	import boxesandworlds.gui.ViewEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sah
	 */
	public class GamePage extends Page
	{
		private var _ui:Sprite;
		private var _game:Game;
		private var _params:Object;
		
		public function GamePage(params:Object = null) 
		{
			_params = params;
			super(UIManager.GAME_PAGE_ID);
		}
		
		override public function load():void {
			_game.addEventListener(ViewEvent.LOAD_COMPLETE, gameLoadComplete);
			_game.load();
		}
		
		override public function setup():void {
			_ui = new Sprite();
			addChild(_ui);
			
			newGame();
		}
		
		override public function resize():void {
			if (_game) {
				_game.resize();
			}
		}
		
		public function newGame():void {			
			setupGame();
		}
		
		private function setupGame():void {
			_game = new Game();
			_ui.addChild(_game);
			//var params:Object = { xmlLevelPath:"../assets/level1.xml" };
			//var params:Object = { xmlLevelPath:"../assets/level2.xml" };
			//var params:Object = { xmlLevelPath:"../assets/level3.xml" };
			var params:Object = { xmlLevelPath:"../assets/level4.xml" };
			_game.init(params);
		}
		
		private function gameLoadComplete(e:ViewEvent):void 
		{
			newGameLoadComplete();
		}
		
		private function newGameLoadComplete(e:ViewEvent = null):void 
		{
			_game.addEventListener(Game.BACK, backHandler);
			_game.addEventListener(Game.GAME_COMPLETE, completeHandler);
			_game.addEventListener(Game.GAME_STARTED, startHandler);
			_game.start();
		}
		
		private function startHandler(e:Event):void 
		{
			_game.removeEventListener(Game.GAME_STARTED, startHandler);
			Core.ui.hidePreloader();
			doLoadComplete();
		}
		
		private function completeHandler(e:Event):void 
		{
			Core.ui.showPage(UIManager.MAIN_PAGE_ID);
		}
		
		private function backHandler(e:Event):void 
		{
			Core.ui.showPage(UIManager.MAIN_PAGE_ID);
		}
	}

}