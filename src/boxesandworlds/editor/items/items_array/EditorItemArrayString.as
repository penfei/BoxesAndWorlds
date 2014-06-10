package boxesandworlds.editor.items.items_array {
	import boxesandworlds.editor.utils.EditorUtils;
	import editor.EditorAttributeArrayStringUI;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author xiiii
	 */
	public class EditorItemArrayString extends EditorItemArray {
		
		// const
		static public const DEFAULT_VALUE:String = "value";
		
		// ui
		private var _ui:EditorAttributeArrayStringUI;
		
		// vars
		private var _defaultValue:String;
		
		public function EditorItemArrayString(defaultValue:String = DEFAULT_VALUE) {
			_defaultValue = defaultValue;
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
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeArrayStringUI;
			addChild(_ui);
			
			_ui.labelName.text = _defaultValue;
			_ui.labelName.selectable = true;
			_ui.labelName.type = TextFieldType.INPUT;
		}
		
	}

}