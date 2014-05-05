package boxesandworlds.editor.items {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author xiii
	 */
	public class EditorItem extends Sprite {
		
		// const
		static public const EDITOR_ITEM_001:int = 1;
		static public const EDITOR_ITEM_002:int = 2;
		
		// ui
		private var _ui:MovieClip;
		private var _areaWarning:Sprite;
		
		// vars
		private var _id:int;
		
		public function EditorItem(id:int, ui:MovieClip) {
			_id = id;
			_ui = ui;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		// protected
		protected function setup():void {
			if (_ui != null) {
				addChild(_ui);
				
				_areaWarning = new Sprite();
				_areaWarning.graphics.beginFill(0xff0000, .5);
				_areaWarning.graphics.drawRect(0, 0, _ui.width, _ui.height);
				_areaWarning.graphics.endFill();
				_areaWarning.mouseChildren = _areaWarning.mouseEnabled = false;
				_areaWarning.alpha = 0;
				addChild(_areaWarning);
			}
		}
		
	}

}