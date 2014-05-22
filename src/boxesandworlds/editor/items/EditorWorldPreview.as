package boxesandworlds.editor.items {
	import com.greensock.TweenMax;
	import editor.EditorWorldPreviewUI;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorWorldPreview extends Sprite {
		
		// ui
		private var _ui:EditorWorldPreviewUI;
		
		// vars
		private var _id:int;
		
		public function EditorWorldPreview(id:int) {
			_id = id;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		// public
		public function destroy():void {
			
		}
		
		public function setupSelect(value:Boolean):void {
			if (value) {
				TweenMax.to(_ui.mcSelect, .3, { alpha:1 } );
			}else {
				TweenMax.to(_ui.mcSelect, .3, { alpha:0 } );
			}
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorWorldPreviewUI;
			_ui.label.text = String(_id);
			_ui.label.mouseEnabled = false;
			addChild(_ui);
		}
		
	}
}