package boxesandworlds.editor {
	import boxesandworlds.editor.items.EditorItem;
	import editor.EditorAreaItemsUI;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author xiii
	 */
	public class EditorAreaItems extends Sprite {
		
		// ui
		private var _ui:EditorAreaItemsUI;
		private var _items:Vector.<EditorItem>;
		
		public function EditorAreaItems() {
			setup();
		}
		
		// public
		public function addItems(items:Vector.<EditorItem>):void {
			_items = items;
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				
			}
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAreaItemsUI;
			addChild(_ui);
		}
		
	}

}