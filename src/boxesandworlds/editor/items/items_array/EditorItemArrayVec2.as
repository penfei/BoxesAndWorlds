package boxesandworlds.editor.items.items_array {
	import editor.EditorAttributeArrayVec2UI;
	import flash.text.TextFieldType;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author xiiii
	 */
	public class EditorItemArrayVec2 extends EditorItemArray {
		
		// const
		static public const DEFAULT_VALUE:Vec2 = null;
		
		// ui
		private var _ui:EditorAttributeArrayVec2UI;
		
		// vars
		private var _defaultValue:Vec2;
		
		public function EditorItemArrayVec2(defaultValue:Vec2 = DEFAULT_VALUE) {
			_defaultValue = defaultValue == null ? new Vec2(0, 0) : defaultValue;
			setup();
		}
		
		// get
		override public function get valueXML():String {
			var value:String = "";
			value += "<valueX>" + _ui.value1.text + "</valueX>";
			value += "<valueY>" + _ui.value2.text + "</valueY>";
			return value;
		}
		
		override public function get value():String { 
			return _ui.value1.text + " " + _ui.value2.text;
		}
		
		// set
		override public function set value(value:String):void {
			var values:Array = value.split(" ");
			_ui.value1.text = values[0];
			_ui.value2.text = values[1];
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeArrayVec2UI;
			addChild(_ui);
			
			_ui.key1.text = "x:";
			_ui.key2.text = "y:";
			_ui.value1.text = String(_defaultValue.x);
			_ui.value2.text = String(_defaultValue.y);
			_ui.value1.selectable = true;
			_ui.value1.type = TextFieldType.INPUT;
			_ui.value2.selectable = true;
			_ui.value2.type = TextFieldType.INPUT;
		}
		
	}

}