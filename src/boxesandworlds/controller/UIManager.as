package boxesandworlds.controller {
	
	/**
	 * ...
	 * @author Sah
	 */

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import boxesandworlds.gui.page.*;
	import boxesandworlds.gui.popup.*;
	import boxesandworlds.gui.*;
	import symbols.view.MiniPreloaderUI;
	
	public class UIManager extends EventDispatcher {
		static public const NONE_ID:uint = 0;
		
		//pages
		static public const MAIN_PAGE_ID:uint = 101;
		static public const GAME_PAGE_ID:uint = 102;
		static public const SETTINGS_PAGE_ID:uint = 103;
		static public const EDITOR_PAGE_ID:uint = 104;
		
		private var _currentPage:Page = null;
		private var _previosPage:Page = null;
		private var _currentPopup:Popup = null;
		private var _nextPageId:uint = NONE_ID;
		private var _nextPageParams:Object
		private var _nextPopupId:uint = NONE_ID;
		private var _canvas:View;
		private var _miniPreloader:MiniPreloaderUI
		
		public function UIManager(canvas:View){
			_canvas = canvas;
		}
		
		// properties:
		public function get currentPage():Page {return _currentPage;}
		public function get currentPageId():uint {return (currentPage) ? currentPage.id : NONE_ID;}
		public function get currentPopup():Popup {return _currentPopup;}
		public function get currentPopupId():uint {return (currentPopup) ? currentPopup.id : NONE_ID;}
		public function get canvas():View {return _canvas;}
		
		// public:
		/**
		 * инициализация canvas
		 */
		public function init():void {
			//_canvas.stage.addEventListener(Event.RESIZE, resize);
			
			_miniPreloader = new MiniPreloaderUI;
			_canvas.parent.addChild(_miniPreloader);
			hidePreloader();
			
			showPage(MAIN_PAGE_ID);
			
			resize();
		}
		
		public function showPreloader():void {
			_miniPreloader.visible = true;
		}

		public function hidePreloader():void {
			_miniPreloader.visible = false;
		}
		
		public function showPage(pageId:uint, params:Object = null):void {
			if (pageId == currentPageId)
				return;
			_nextPageId = pageId;
			_nextPageParams = params;
			if (currentPage){
				_canvas.setEnabled(false);
				currentPage.addEventListener(ViewEvent.HIDE_ANIMATION_COMPLETE, pageHideAnimationCompleteHandler, false, 0, true);
				currentPage.hideAnimation();
				if (currentPopup) currentPopup.hideAnimation();
			} else {
				showNextPage();
			}
		}
		
		public function showPopup(popupId:uint):void {
			if (popupId == currentPopupId)
				return;
			_nextPopupId = popupId;
			if (currentPopup) {
				currentPopup
				currentPopup.hideAnimation();
			}
			else
				showNextPopup();
		}
		
		// private:
		private function resize(e:Event = null):void 
		{
			_miniPreloader.x = _canvas.stage.stageWidth / 2;
			_miniPreloader.y = _canvas.stage.stageHeight / 2;
			if(_currentPage) _currentPage.resize();
		}
		
		private function showView(view:View):void {
			_canvas.setEnabled(false);
			_canvas.addChild(view);
			view.setup()
			view.addEventListener(ViewEvent.LOAD_COMPLETE, viewLoadCompleteHandler, false, 0, true);
			view.load();
		}
		
		// pages:
		private function showNextPage():void {
			var page:Page = createPage(_nextPageId);
			if (page) {
				showPreloader();
				_nextPageId = NONE_ID;
				_previosPage = _currentPage;
				_currentPage = page;
				showView(page);
			}
		}
		
		private function createPage(pageId:uint):Page {
			switch (pageId) {
				case MAIN_PAGE_ID:
					return new MainPage()
				case SETTINGS_PAGE_ID:
					return new SettingsPage();
				case GAME_PAGE_ID:
					return new GamePage(_nextPageParams);
				case EDITOR_PAGE_ID:
					return new EditorPage();
				default: 
					return null;
			}
		}
		
		// popups:
		private function showNextPopup():void {
			var popup:Popup = createPopup(_nextPopupId);
			if (popup) {
				showPreloader();
				_currentPopup = popup;
				_nextPopupId = NONE_ID;
				popup.addEventListener(ViewEvent.HIDE_ANIMATION_COMPLETE, popupHideAnimationComplete);
				showView(popup);
				_currentPage.setEnabled(false);
			} else {
				_currentPage.setEnabled(true);
			}
		}
		
		private function createPopup(popupId:uint):Popup {
			switch (popupId) {
				default: 
					return null;
			}
		}
		
		private function viewLoadCompleteHandler(event:ViewEvent):void {
			var view:IdView = (event.target as IdView);
			if (view) {
				hidePreloader();
				_canvas.addChild(view);
				if (_previosPage) {
					_canvas.removeChild(_previosPage);
					_previosPage = null;
				}
				view.removeEventListener(ViewEvent.LOAD_COMPLETE, viewLoadCompleteHandler);
				view.addEventListener(ViewEvent.SHOW_ANIMATION_COMPLETE, viewShowAnimationCompleteHandler, false, 0, true);
				view.showAnimation();
			}
		}
		
		private function viewShowAnimationCompleteHandler(event:ViewEvent):void {
			var view:View = (event.target as View);
			if (view){
				view.removeEventListener(ViewEvent.SHOW_ANIMATION_COMPLETE, viewShowAnimationCompleteHandler);
				_canvas.setEnabled(true);
				dispatchEvent(new ViewEvent(ViewEvent.SHOW_ANIMATION_COMPLETE));
			}
		}
		
		private function pageHideAnimationCompleteHandler(event:ViewEvent):void {
			var page:Page = (event.target as Page);
			if (page){
				page.removeEventListener(ViewEvent.HIDE_ANIMATION_COMPLETE, pageHideAnimationCompleteHandler);
				//_canvas.removeChild(page);
				showNextPage();
			}
		}
		
		private function popupHideAnimationComplete(e:ViewEvent):void {
			var popup:Popup = (e.target as Popup);
			if (popup){
				popup.removeEventListener(ViewEvent.HIDE_ANIMATION_COMPLETE, popupHideAnimationComplete);
				_canvas.removeChild(popup);
				_currentPopup = null;
				_currentPage.setEnabled(true);
				showNextPopup();
			}
		}
	
	}
}
