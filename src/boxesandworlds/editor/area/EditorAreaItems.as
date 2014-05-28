package boxesandworlds.editor.area {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.controls.EditorVerticalScroller;
	import boxesandworlds.editor.events.EditorEventNewItem;
	import boxesandworlds.editor.items.EditorItemPreview;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
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
		private var _items:Vector.<EditorItemPreview>;
		private var _scroll:EditorVerticalScroller;
		
		// vars
		private var _library:Array;
		
		public function EditorAreaItems(library:Array) {
			_library = library;
			setup();
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAreaItemsUI;
			addChild(_ui);
			
			var content:Sprite = new Sprite();
			var len:uint = _library.length;
			_items = new Vector.<EditorItemPreview>();
			_items.length = len;
			
			var attributes:Vector.<Attribute>;
			for (var i:int = 0; i < len; ++i) {
				var item:EditorItemPreview = new EditorItemPreview(EditorUtils.getItemId(String(_library[i])), _library[i].attributes());
				_items[i] = item;
				item.x = 10 + 10 * (i % 5) + 55 * (i % 5);
				item.y = 10 + 10 * (int(i / 5)) + 55 * (int(i / 5));
				item.buttonMode = true;
				item.addEventListener(MouseEvent.ROLL_OVER, itemOverHandler);
				item.addEventListener(MouseEvent.ROLL_OUT, itemOutHandler);
				item.addEventListener(MouseEvent.MOUSE_DOWN, itemDownHandler);
				content.addChild(item);
			}
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x000000, 0);
			s.graphics.drawRect(0, 0, 1, 30);
			s.graphics.endFill();
			s.y = content.height;
			content.addChildAt(s, 0);
			
			_scroll = new EditorVerticalScroller(new EditorScrollItemsUI, content, Core.stage);
			addChild(_scroll);
		}
		
		// handlers
		private function itemOverHandler(e:MouseEvent):void {
			var target:EditorItemPreview = e.target as EditorItemPreview;
			if (target != null) {
				target.showHint();
			}
		}
		
		private function itemOutHandler(e:MouseEvent):void {
			var target:EditorItemPreview = e.target as EditorItemPreview;
			if (target != null) {
				target.hideHint();
			}
		}
		
		private function itemDownHandler(e:MouseEvent):void {
			var item:EditorItemPreview = e.currentTarget as EditorItemPreview;
			if (item != null) {
				dispatchEvent(new EditorEventNewItem(EditorEventNewItem.NEW_ITEM, item.id, item.attributes));
			}
		}
		
	}

}