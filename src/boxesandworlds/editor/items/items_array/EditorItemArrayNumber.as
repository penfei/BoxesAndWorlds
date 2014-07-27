package boxesandworlds.editor.items.items_array {
	import boxesandworlds.editor.events.EditorEventChangeContainerItem;
	import boxesandworlds.editor.utils.EditorUtils;
	import editor.EditorAttributeArrayNumberUI;
	import flash.events.Event;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author xiiii
	 */
	public class EditorItemArrayNumber extends EditorItemArray {
		
		// const
		static public const DEFAULT_VALUE:String = "0";
		
		// ui
		private var _ui:EditorAttributeArrayNumberUI;
		
		// vars
		private var _defaultValue:String;
		private var _index:int;
		
		public function EditorItemArrayNumber(defaultValue:String = DEFAULT_VALUE, index:int = -1) {
			_defaultValue = defaultValue;
			_index = index;
			setup();
		}
		
		// get
		override public function get valueXML():String {
			return EditorUtils.cutSideSpaces(_ui.labelName.text);
		}
		
		override public function get value():String { 
			return EditorUtils.cutSideSpaces(_ui.labelName.text);
		}
		
		// set
		override public function set value(value:String):void {
			_ui.labelName.text = value;
		}
		
		public function set index(value:int):void { _index = value; }
		
		// public
		public function setupListenersForContainers():void {
			_ui.labelName.addEventListener(Event.CHANGE, containerIdChangeHandler);
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeArrayNumberUI;
			addChild(_ui);
			
			_ui.labelName.text = _defaultValue;
			_ui.labelName.selectable = true;
			_ui.labelName.type = TextFieldType.INPUT;
			_ui.labelName.restrict = "0-9.";
		}
		
		// handlers
		private function containerIdChangeHandler(e:Event):void {
			dispatchEvent(new EditorEventChangeContainerItem(EditorEventChangeContainerItem.CHANGE_CONTAINER, _index, int(_ui.labelName.text), true));
		}
		
	}

}