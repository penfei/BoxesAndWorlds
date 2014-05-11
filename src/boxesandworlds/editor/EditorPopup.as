package boxesandworlds.editor {
	import editor.EditorPopupUI;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorPopup extends Sprite{
		
		// const
		static public const EDITOR_SAVE_LEVEL:String = "editorSaveLevel";
		static public const EDITOR_CLEAR_LEVEL:String = "editorClearLevel";
		static public const EDITOR_EXIT:String = "editorExit";
		static public const EDITOR_CANCEL_POPUP:String = "editorCancelPopup";
		
		// ui
		private var _ui:EditorPopupUI;
		
		// vars
		private var _type:String;
		
		public function EditorPopup() {
			setup();
		}
		
		// public
		public function setupType(type:String):void {
			_type = type;
			switch(_type) {
				case EDITOR_SAVE_LEVEL:
					_ui.label.text = "сохранить уровень?".toUpperCase();
					break;
					
				case EDITOR_CLEAR_LEVEL:
					_ui.label.text = "очистить весь уровень?".toUpperCase();
					break;
					
				case EDITOR_EXIT:
					_ui.label.text = "выйти из редактора?".toUpperCase();
					break;
			}
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorPopupUI;
			addChild(_ui);
			
			_ui.btnYes.buttonMode = _ui.btnNo.buttonMode = true;
			
			_ui.btnYes.addEventListener(MouseEvent.CLICK, btnYesClickHandler);
			_ui.btnNo.addEventListener(MouseEvent.CLICK, btnNoClickHandler);
		}
		
		// handlers
		private function btnYesClickHandler(e:MouseEvent):void {
			switch(_type) {
				case EDITOR_SAVE_LEVEL:
					dispatchEvent(new Event(EDITOR_SAVE_LEVEL));
					break;
					
				case EDITOR_CLEAR_LEVEL:
					dispatchEvent(new Event(EDITOR_CLEAR_LEVEL));
					break;
					
				case EDITOR_EXIT:
					dispatchEvent(new Event(EDITOR_EXIT));
					break;
			}
		}
		
		private function btnNoClickHandler(e:MouseEvent):void {
			dispatchEvent(new Event(EDITOR_CANCEL_POPUP));
		}
		
	}

}