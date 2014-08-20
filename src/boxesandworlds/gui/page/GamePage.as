package boxesandworlds.gui.page {
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.UIManager;
	import boxesandworlds.game.controller.Game;
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
			Core.ui.showPreloader();
			_game.addEventListener(ViewEvent.LOAD_COMPLETE, newGameLoadComplete);
			_game.load();
		}
		
		override public function setup():void {
			_ui = new Sprite();
			addChild(_ui);
			
			newGame({ xmlLevelPath:"../assets/level4.xml" });
		}
		
		override public function resize():void {
			if (_game) {
				_game.resize();
			}
		}
		
		public function newGame(params:Object):void {
			_ui.removeChildren();
			_game = new Game();
			Core.data.setGame(_game);
			_ui.addChild(_game);
			_game.init(params);
		}
		
		private function newGameLoadComplete(e:ViewEvent = null):void 
		{
			Core.ui.hidePreloader();
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
			if (_game.data.completeParams) {
				newGame(_game.data.completeParams);
				_game.addEventListener(ViewEvent.LOAD_COMPLETE, newGameLoadComplete);
				_game.load();
			} else Core.ui.showPage(UIManager.MAIN_PAGE_ID);
		}
		
		private function backHandler(e:Event):void 
		{
			Core.ui.showPage(UIManager.MAIN_PAGE_ID);
		}
	}

}