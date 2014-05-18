package boxesandworlds.editor.items {
	import boxesandworlds.game.data.Attribute;
	import com.greensock.TweenMax;
	import editor.EditorItemPreviewUI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItemPreview extends Sprite {
		
		// ui
		//private var _ui:MovieClip;
		private var _ui:EditorItemPreviewUI;
		private var _mcHint:Sprite;
		
		// vars
		private var _id:String;
		private var _attributes:Vector.<Attribute>;
		
		public function EditorItemPreview(id:String, attributes:Vector.<Attribute>) {
			_id = id;
			_attributes = attributes;
			setup();
		}
		
		// get
		public function get id():String { return _id; }
		
		public function get attributes():Vector.<Attribute> { return _attributes; }
		
		// public
		public function showHint():void {
			TweenMax.to(_mcHint, .3, { alpha:1 } );
		}
		
		public function hideHint():void {
			TweenMax.to(_mcHint, .3, { alpha:0 } );
		}
		
		// protected
		protected function setup():void {
			//_ui = new EditorItemsEnum.EDITOR_ITEMS_UI_PREVIEW_CLASS[_id]();
			_ui = new EditorItemPreviewUI;
			_ui.label.text = String(_id);
			_ui.label.mouseEnabled = false;
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