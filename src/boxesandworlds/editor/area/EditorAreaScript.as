package boxesandworlds.editor.area {
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import editor.EditorAreaScriptUI;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaScript extends Sprite {
		
		// const
		static public const EDITOR_CHANGED_SCRIPT:String = "editorChangedScript";
		private const DURATION_SECONDS_BEFORE_CHANGE:Number = 3;
		
		// ui
		private var _ui:EditorAreaScriptUI;
		
		public function EditorAreaScript() {
			setup();
		}
		
		// set
		public function set levelScript(levelScriptName:String):void {
			_ui.label.text = levelScriptName;
		}
		
		public function get levelScript():String { return _ui.label.text; }
		
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
			_ui.label.addEventListener(Event.CHANGE, scriptChangeHandler);
		}
		
		// handlers
		private function scriptChangeHandler(e:Event):void {
			TweenMax.killTweensOf(_ui.mcProgress.mc);
			_ui.mcProgress.mc.x = - _ui.mcProgress.mc.width;
			TweenMax.to(_ui.mcProgress.mc, DURATION_SECONDS_BEFORE_CHANGE, { x:0, ease:Linear.easeNone, onComplete: function scriptChanged():void {
				dispatchEvent(new Event(EDITOR_CHANGED_SCRIPT));
			}});
		}
		
	}
}