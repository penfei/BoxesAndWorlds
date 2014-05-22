package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventSetUpAttribute extends Event {
		
		// const
		static public const SET_UP_ATTRIBUTE_ENUM:String = "editorEventSetUpAttributeEnum";
		
		// vars
		private var _id:int;
		
		public function EditorEventSetUpAttribute(type:String, id:int, bubbles:Boolean = false, cancelable:Boolean = false) {
			_id = id;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get id():int { return _id; }
		
	}

}