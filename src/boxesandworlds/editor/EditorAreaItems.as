package boxesandworlds.editor {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.controls.EditorVerticalScroller;
	import boxesandworlds.editor.items.EditorItem;
	import boxesandworlds.editor.items.EditorItem001;
	import boxesandworlds.editor.items.EditorItem002;
	import editor.EditorAreaItemsUI;
	import editor.EditorScrollItemsUI;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaItems extends Sprite {
		
		// ui
		private var _ui:EditorAreaItemsUI;
		private var _items:Vector.<EditorItem>;
		private var _scroll:EditorVerticalScroller;
		
		public function EditorAreaItems() {
			setup();
		}
		
		// public
		public function addItems(items:Vector.<EditorItem>):void {
			_items = items;
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				
			}
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAreaItemsUI;
			addChild(_ui);
			
			var content:Sprite = new Sprite();
			_items = new Vector.<EditorItem>();
			var len:int = 58;
			_items.length = len;
			for (var i:uint = 0; i < len; ++i) {
				var item:EditorItem;
				if (i % 2 == 0) {
					item = new EditorItem001();
				}else {
					item = new EditorItem002();
				}
				_items[i] = item;
				item.x = 10 + 10 * (i % 5) + 55 * (i % 5);
				item.y = 10 + 10 * (int(i / 5)) + 55 * (int(i / 5));
				item.buttonMode = true;
				item.addEventListener(MouseEvent.ROLL_OVER, itemOverHandler);
				item.addEventListener(MouseEvent.ROLL_OUT, itemOutHandler);
				content.addChild(item);
			}
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x000000, 0);
			s.graphics.drawRect(0, 0, 1, 30);
			s.graphics.endFill();
			s.y = content.height;
			content.addChildAt(s, 0);
			
			_scroll = new EditorVerticalScroller(new EditorScrollItemsUI, content, Core.instance.stage);
			addChild(_scroll);
		}
		
		private function itemOverHandler(e:MouseEvent):void 
		{
			var target:EditorItem = e.target as EditorItem;
			if (target != null) {
				target.showHint();
			}
		}
		
		private function itemOutHandler(e:MouseEvent):void 
		{
			var target:EditorItem = e.target as EditorItem;
			if (target != null) {
				target.hideHint();
			}
		}
		
	}

}