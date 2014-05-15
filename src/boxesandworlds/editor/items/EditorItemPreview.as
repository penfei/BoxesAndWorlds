package boxesandworlds.editor.items {
	import com.greensock.TweenMax;
	import editor.EditorItemPreview001UI;
	import editor.EditorItemPreview002UI;
	import editor.EditorItemPreview003UI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItemPreview extends Sprite {
		
		// ui
		private var _ui:MovieClip;
		private var _mcHint:Sprite;
		
		// vars
		private var _id:int;
		
		public function EditorItemPreview(id:int) {
			_id = id;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		// public
		public function showHint():void {
			TweenMax.to(_mcHint, .3, { alpha:1 } );
		}
		
		public function hideHint():void {
			TweenMax.to(_mcHint, .3, { alpha:0 } );
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorItemsEnum.EDITOR_ITEMS_UI_PREVIEW_CLASS[_id]();
			addChild(_ui);
			
			_mcHint = new Sprite();
			_mcHint.graphics.beginFill(0xffffff, .15);
			_mcHint.graphics.drawRect(0, 0, _ui.width, _ui.height);
			_mcHint.graphics.endFill();
			_mcHint.mouseChildren = _mcHint.mouseEnabled = false;
			_mcHint.alpha = 0;
			addChildAt(_mcHint, 0);
		}
		
	}
}