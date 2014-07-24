package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventChangeViewItem extends Event {
		
		// const
		static public const CHANGE_VIEW:String = "editorEventChangeViewItem";
		static public const ADD_FIELD_VIEW:String = "editorEventAddFieldViewItem";
		static public const REMOVE_FIELD_VIEW:String = "editorEventRemoveFieldViewItem";
		
		// vars
		private var _url:String;
		private var _id:int;
		
		public function EditorEventChangeViewItem(type:String, url:String = "", id:int = -1, bubbles:Boolean = false, cancelable:Boolean = false) {
			_url = url;
			_id = id;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get url():String { return _url; }
		
		public function get id():int { return _id; }
		
	}
}