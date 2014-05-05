package boxesandworlds.gui.page {
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.UIManager;
	import boxesandworlds.editor.EditorPopup;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import editor.EditorPageUI;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EditorPage extends Page {
		
		// ui
		private var _ui:EditorPageUI;
		private var _popup:EditorPopup;
		
		public function EditorPage() {
			super(UIManager.EDITOR_PAGE_ID);
		}
		
		// public
		override public function hideAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			doHideAnimation(_ui, sec);
		}

		override public function showAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			doShowAnimation(_ui, sec);
		}

		override public function setup():void {
			_ui = new EditorPageUI;
			addChild(_ui);
			
			_popup = new EditorPopup;
			_popup.x = _ui.x + (_ui.width - _popup.width) / 2;
			_popup.alpha = 0;
			_popup.mouseChildren = _popup.mouseEnabled = false;
			addChild(_popup);
			_popup.addEventListener(EditorPopup.EDITOR_CANCEL_POPUP, popupCancelHandler);
			_popup.addEventListener(EditorPopup.EDITOR_SAVE_LEVEL, popupSaveLevelHandler);
			_popup.addEventListener(EditorPopup.EDITOR_CLEAR_LEVEL, popupClearLevelHandler);
			_popup.addEventListener(EditorPopup.EDITOR_EXIT, popupExitHandler);
			
			_ui.btnSave.buttonMode = _ui.btnClear.buttonMode = _ui.btnExit.buttonMode = true;
			
			_ui.btnSave.addEventListener(MouseEvent.CLICK, btnSaveClickHandler);
			_ui.btnClear.addEventListener(MouseEvent.CLICK, btnClearClickHandler);
			_ui.btnExit.addEventListener(MouseEvent.CLICK, btnExitClickHandler);
		}
		
		protected function showPopup():void {
			_ui.mouseChildren = _ui.mouseEnabled = false;
			_popup.alpha = 0;
			_popup.y = _ui.y + (_ui.height - _popup.height) / 2 - 50;
			_popup.mouseChildren = _popup.mouseEnabled = true;
			TweenMax.to(_popup, .5, { y: _ui.y + (_ui.height - _popup.height) / 2, alpha:1, ease:Expo.easeOut } );
		}
		
		protected function hidePopup():void {
			_ui.mouseChildren = _ui.mouseEnabled = true;
			_popup.mouseChildren = _popup.mouseEnabled = false;
			TweenMax.to(_popup, .4, { y: _ui.y + (_ui.height - _popup.height) / 2 + 50, alpha:0, ease:Linear.easeNone } );
		}
		
		// handlers
		private function btnSaveClickHandler(e:MouseEvent):void {
			_popup.setupType(EditorPopup.EDITOR_SAVE_LEVEL);
			showPopup();
		}
		
		private function btnClearClickHandler(e:MouseEvent):void {
			_popup.setupType(EditorPopup.EDITOR_CLEAR_LEVEL);
			showPopup();
		}
		
		private function btnExitClickHandler(e:MouseEvent):void {
			_popup.setupType(EditorPopup.EDITOR_EXIT);
			showPopup();
		}
		
		private function popupCancelHandler(e:Event):void {
			hidePopup();
		}
		
		private function popupSaveLevelHandler(e:Event):void {
			hidePopup();
		}
		
		private function popupClearLevelHandler(e:Event):void {
			hidePopup();
		}
		
		private function popupExitHandler(e:Event):void {
			hidePopup();
			Core.ui.showPage(UIManager.MAIN_PAGE_ID);
		}
		
	}

}