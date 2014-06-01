package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventWorld extends Event {
		
		// const
		static public const ADD_WORLD:String = "editorEventAddWorld";
		static public const REMOVE_WORLD:String = "editorEventRemoveWorld";
		static public const SELECT_WORLD:String = "editorSelectWorld";
		
		// vars
		private var _id:int;
		private var _addId:int;// нужен для того, чтобы понять какой мир автоматически выбран следующим после удаления предыдущего
		
		public function EditorEventWorld(type:String, id:int, addId:int = -1, bubbles:Boolean = false, cancelable:Boolean = false) {
			_id = id;
			_addId = addId;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get id():int { return _id; }
		
		public function get addId():int { return _addId; }
		
	}

}