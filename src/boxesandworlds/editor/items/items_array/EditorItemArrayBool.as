package boxesandworlds.editor.items.items_array {
	import editor.EditorAttributeArrayBoolUI;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author xiiii
	 */
	public class EditorItemArrayBool extends EditorItemArray {
		
		// const
		static public const DEFAULT_VALUE:String = "true";
		
		// ui
		private var _ui:EditorAttributeArrayBoolUI;
		
		// vars
		private var _defaultValue:String;
		
		public function EditorItemArrayBool(defaultValue:String = DEFAULT_VALUE) {
			_defaultValue = defaultValue;
			setup();
		}
		
		// get
		override public function get valueXML():String {
			return String(_ui.mcValue.mcCheck.visible);
		}
		
		override public function get value():String { 
			return String(_ui.mcValue.mcCheck.visible);
		}
		
		// set
		override public function set value(value:String):void {
			if (value == "true") {
				_ui.mcValue.mcCheck.visible = true;
			}else if (value == "false") {
				_ui.mcValue.mcCheck.visible = false;
			}
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeArrayBoolUI;
			addChild(_ui);
			
			_ui.buttonMode = true;
			_ui.addEventListener(MouseEvent.CLICK, uiClickHandler);
			
			if (_defaultValue == "true") {
				_ui.mcValue.mcCheck.visible = true;
			}else if (_defaultValue == "false") {
				_ui.mcValue.mcCheck.visible = false;
			}
		}
		
		private function uiClickHandler(e:MouseEvent):void {
			_ui.mcValue.mcCheck.visible = !_ui.mcValue.mcCheck.visible;
		}
		
	}

}