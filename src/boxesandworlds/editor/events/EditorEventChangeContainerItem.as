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
		private var _index:int;
		private var _value:int;
		
		public function EditorEventChangeContainerItem(type:String, index:int = -1, value:int = -1, bubbles:Boolean = false, cancelable:Boolean = false) {
			_index = index;
			_value = value;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get index():int { return _index; }
		
		public function get value():int { return _value; }
		
	}
}