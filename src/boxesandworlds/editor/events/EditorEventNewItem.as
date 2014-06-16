package boxesandworlds.editor.events {
	import boxesandworlds.game.data.Attribute;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventNewItem extends Event {
		
		// const
		static public const NEW_ITEM:String = "editorEventNewItem";
		
		// vars
		private var _attributes:Vector.<Attribute>;
		
		public function EditorEventNewItem(type:String, attributes:Vector.<Attribute>, bubbles:Boolean = false, cancelable:Boolean = false) {
			_attributes = attributes;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get attributes():Vector.<Attribute> { return _attributes; }
		
	}

}