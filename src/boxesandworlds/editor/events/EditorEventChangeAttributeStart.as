package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventChangeAttributeStart extends Event {
		
		// const
		static public const CHANGE_ATTRIBUTE_START:String = "editorEventChangeAttributeStart";
		
		// vars
		private var _valueX:Number;
		private var _valueY:Number;
		
		public function EditorEventChangeAttributeStart(type:String, valueX:Number, valueY:Number, bubbles:Boolean = false, cancelable:Boolean = false) {
			_valueX = valueX;
			_valueY = valueY;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get valueX():Number { return _valueX; }
		
		public function get valueY():Number { return _valueY; }
		
	}

}