package boxesandworlds.editor.events {
	import boxesandworlds.editor.items.EditorItem;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventAttributes extends Event {
		
		// const
		static public const SHOW_ATTRIBUTES:String = "editorEventShowAttributes";
		static public const HIDE_ATTRIBUTES:String = "editorEventHideAttributes";
		
		// vars
		private var _item:EditorItem;
		
		public function EditorEventAttributes(type:String, item:EditorItem = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			_item = item;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get item():EditorItem { return _item; }
		
	}

}