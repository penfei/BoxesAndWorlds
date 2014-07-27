package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventUpdateViewItem extends Event {
		
		// const
		static public const UPDATE_VIEW:String = "editorEventUpdateViewItem";
		
		// vars
		private var _indexItem:int;
		private var _idView:int;
		
		public function EditorEventUpdateViewItem(type:String, indexItem:int, idView:int, bubbles:Boolean = false, cancelable:Boolean = false) {
			_indexItem = indexItem;
			_idView = idView;
			super(type, bubbles, cancelable);			
		}
		
		// get
		public function get indexItem():int { return _indexItem; }
		
		public function get idView():int { return _idView; }
		
	}
}