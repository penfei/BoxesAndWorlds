package boxesandworlds.editor.items.items_array {
	import boxesandworlds.editor.utils.EditorUtils;
	import editor.EditorAttributeArrayNumberUI;
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
		
		public function EditorItemArrayNumber(defaultValue:String = DEFAULT_VALUE) {
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
			_ui = new EditorAttributeArrayNumberUI;
			addChild(_ui);
			
			_ui.labelName.text = _defaultValue;
			_ui.labelName.selectable = true;
			_ui.labelName.type = TextFieldType.INPUT;
			_ui.labelName.restrict = "0-9.";
		}
		
	}

}