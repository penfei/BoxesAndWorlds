package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventUpdateContainerItem extends Event {
		
		// const
		static public const UPDATE_CONTAINER:String = "editorEventUpdateContainerItem";
		
		// vars
		private var _indexItem:int;
		private var _indexView:int;
		private var _idContainer:int;
		
		public function EditorEventUpdateContainerItem(type:String, indexItem:int, indexView:int, idContainer:int, bubbles:Boolean = false, cancelable:Boolean = false) {
			_indexItem = indexItem;
			_indexView = indexView;
			_idContainer = idContainer;
			super(type, bubbles, cancelable);			
		}
		
		// get
		public function get indexItem():int { return _indexItem; }
		
		public function get indexView():int { return _indexView; }
		
		public function get idContainer():int { return _idContainer; }
		
	}
}