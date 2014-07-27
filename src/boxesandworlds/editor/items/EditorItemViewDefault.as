package boxesandworlds.editor.items {
	import editor.EditorItemUI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItemViewDefault extends Sprite {
		
		// ui
		private var _ui:EditorItemUI;
		private var _item:EditorItem;
		
		public function EditorItemViewDefault(item:EditorItem) {
			_item = item;
			setup();
		}
		
		// get
		public function get editorItem():EditorItem { return _item; }
		
		public function get mcSelect():MovieClip { return _ui.mcSelect; }
		
		// protected
		protected function setup():void {
			_ui = new EditorItemUI;
			addChild(_ui);
		}
		
	}
}