package boxesandworlds.editor.items {
	import boxesandworlds.controller.Core;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItemView extends Sprite {
		
		// const
		static public const UPDATE_ITEM_SIZE:String = "editorEventUpdateItemSize";
		
		// vars
		private var _url:String;
		private var _containerId:int;
		
		// ui
		private var _ui:Bitmap;
		
		public function EditorItemView() {
			
		}
		
		// get
		public function get containerId():int { return _containerId; }
		
		// public
		public function destroy():void {
			if (_ui != null) {
				if (_ui.bitmapData != null) {
					_ui.bitmapData.dispose();
				}
				if (_ui.parent != null) {
					_ui.parent.removeChild(_ui);
				}
				_ui = null;
			}
		}
		
		public function loadView(url:String, containerId:int):void {
			_url = url;
			_containerId = containerId;
			Core.content.load(_url, viewLoadedHandler);
		}
		
		public function setupImage(image:Bitmap):void {
			destroyView();
			_ui = image;
			if (_ui != null) {
				addChild(_ui);
			}
			dispatchEvent(new Event(UPDATE_ITEM_SIZE));
		}
		
		// protected
		protected function destroyView():void {
			if (_ui != null) {
				if (_ui.parent != null) {
					_ui.parent.removeChild(_ui);
				}
				_ui = null;
			}
		}
		
		// handlers
		private function viewLoadedHandler():void {
			destroyView();
			_ui = new Bitmap((Core.content.library[_url] as Bitmap).bitmapData.clone());
			if (_ui != null) {
				addChild(_ui);
			}
			dispatchEvent(new Event(UPDATE_ITEM_SIZE));
		}
		
	}
}