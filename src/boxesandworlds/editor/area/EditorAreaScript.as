package boxesandworlds.editor.area {
	import editor.EditorAreaScriptUI;
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaScript extends Sprite {
		
		// ui
		private var _ui:EditorAreaScriptUI;
		
		public function EditorAreaScript() {
			setup();
		}
		
		// set
		public function set levelScript(levelScriptName:String):void {
			_ui.label.text = levelScriptName;
		}
		
		// public
		public function getLevelScriptXML(xml:XML):XML {
			xml.appendChild(XML("<levelScript scriptName='" + _ui.label.text + "'></levelScript>"));
			return xml;
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAreaScriptUI;
			addChild(_ui);
			
			_ui.label.selectable = true;
			_ui.label.type = TextFieldType.INPUT;
		}
		
	}
}