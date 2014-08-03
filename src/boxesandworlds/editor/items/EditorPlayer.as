package boxesandworlds.editor.items {
	import com.greensock.TweenMax;
	import editor.EditorPlayerUI;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorPlayer extends Sprite {
		
		// const
		static public const ADD_PLAYER:String = "editorEventAddPlayer";
		
		// ui
		private var _ui:EditorPlayerUI;
		
		// vars
		private var _isShowedWarning:Boolean;
		
		public function EditorPlayer() {
			setup();
		}
		
		// get
		public function get isShowedWarning():Boolean { return _isShowedWarning; }
		
		// public
		public function destroy():void {
			if (_ui != null) {
				if (_ui.parent != null) {
					_ui.parent.removeChild(_ui);
				}
				_ui = null;
			}
		}
		
		public function showWarning():void {
			_isShowedWarning = true;
			TweenMax.to(_ui.mcWarning, .3, { alpha:1 } );
		}
		
		public function hideWarning():void {
			_isShowedWarning = false;
			TweenMax.to(_ui.mcWarning, .3, { alpha:0 } );
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorPlayerUI;
			addChild(_ui);
		}
		
	}
}