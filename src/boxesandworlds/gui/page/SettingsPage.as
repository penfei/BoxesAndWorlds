package boxesandworlds.gui.page {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.UIManager;
	import symbols.view.MainPageUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class SettingsPage extends Page
	{
		private var _ui:MainPageUI
		
		public function SettingsPage() 
		{
			super(UIManager.SETTINGS_PAGE_ID);
		}
		
		override public function setup():void {
			_ui = new MainPageUI();
			//Core.data.keyboard.setup(_ui.main.settings);
			//_ui.main.choice.btn.mouseChildren = _ui.main.newGame.btn.mouseChildren = _ui.main.settings.btn.mouseChildren= false;
			
			_ui.btnGame.buttonMode = _ui.btnHow.buttonMode = _ui.btnSettings.buttonMode = true;
			_ui.btnGame.addEventListener(MouseEvent.CLICK, gameClickHandler);
			_ui.btnSettings.addEventListener(MouseEvent.CLICK, settigsClickHandler);
			addChild(_ui);
		}
		
		private function settigsClickHandler(e:MouseEvent):void 
		{
			
		}
		
		private function gameClickHandler(e:MouseEvent):void 
		{
			Core.ui.showPage(UIManager.GAME_PAGE_ID);
		}
		
		override public function resize():void {
			
		}
	}

}