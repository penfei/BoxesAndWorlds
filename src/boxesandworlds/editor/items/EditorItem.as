package boxesandworlds.editor.items {
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItem extends Sprite {
		
		// ui
		private var _ui:MovieClip;
		private var _mcWarning:Sprite;
		
		// vars
		private var _id:int;
		
		public function EditorItem(id:int, ui:MovieClip) {
			_id = id;
			_ui = ui;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		// public
		public function showWarning():void {
			TweenMax.to(_mcWarning, .3, { alpha:1 } );
		}
		
		public function hideWarning():void {
			TweenMax.to(_mcWarning, .3, { alpha:0 } );
		}
		
		// protected
		protected function setup():void {
			if (_ui != null) {
				addChild(_ui);
				
				_mcWarning = new Sprite();
				_mcWarning.graphics.beginFill(0xff0000, .5);
				_mcWarning.graphics.drawRect(0, 0, _ui.width, _ui.height);
				_mcWarning.graphics.endFill();
				_mcWarning.mouseChildren = _mcWarning.mouseEnabled = false;
				_mcWarning.alpha = 0;
				addChild(_mcWarning);
			}
		}
		
	}
}