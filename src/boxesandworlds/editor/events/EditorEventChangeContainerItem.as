package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventChangeContainerItem extends Event {
		
		// const
		static public const CHANGE_CONTAINER:String = "editorEventChangeContainerItem";
		static public const ADD_FIELD_CONTAINER:String = "editorEventAddFieldContainerItem";
		static public const REMOVE_FIELD_CONTAINER:String = "editorEventRemoveFieldContainerItem";
		
		// vars
		private var _id:int;
		private var _value:int;
		
		public function EditorEventChangeContainerItem(type:String, id:int = -1, value:int = -1, bubbles:Boolean = false, cancelable:Boolean = false) {
			_id = id;
			_value = value;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get id():int { return _id; }
		
		public function get value():int { return _value; }
		
	}
}