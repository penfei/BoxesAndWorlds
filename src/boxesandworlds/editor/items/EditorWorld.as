package boxesandworlds.editor.items {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.area.EditorAreaAttributes;
	import boxesandworlds.editor.events.EditorEventAttributes;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorWorld extends Sprite {
		
		// ui
		private var _containerItems:Sprite;
		
		private var _items:Vector.<EditorItem>;
		private var _currentItem:EditorItem;
		private var _label:TextField;
		
		// vars
		private var _id:int;
		private var _uniqueItemId:int = EditorAreaAttributes.UNIQUE_ID_UNSELECT_ITEM + 1;
		
		public function EditorWorld(id:int) {
			_id = id;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		// public
		public function destroy():void {
			
		}
		
		public function addItem(id:String, attributes:Vector.<Attribute>):void {
			disableMoveItems();
			
			var item:EditorItem = new EditorItem(id, _uniqueItemId++, attributes);
			_items.push(item);
			setupMovebleItem(item, true);
		}
		
		public function setupSelectableItem(item:EditorItem = null):void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				if (item != null && item == _items[i]) {
					if (!item.isSelectable) {
						_items[i].setupSelectable(true);
						dispatchEvent(new EditorEventAttributes(EditorEventAttributes.SHOW_ATTRIBUTES, item, true));
					}
				}else {
					_items[i].setupSelectable(false);
				}
			}
		}
		
		// protected
		protected function setup():void {
			_containerItems = new Sprite();
			addChild(_containerItems);
			
			_items = new Vector.<EditorItem>();
			
			_label = new TextField();
			_label.x = 10;
			_label.y = 10;
			_label.text = String(_id);
			_label.mouseEnabled = false;
			addChild(_label);
		}
		
		protected function setupMovebleItem(item:EditorItem, isAdd:Boolean = false):void {
			_currentItem = item;
			var posX:Number = _currentItem.x;
			var posY:Number = _currentItem.y;
			_currentItem.x = Core.stage.mouseX - _currentItem.width / 2;
			_currentItem.y = Core.stage.mouseY - _currentItem.height / 2;
			_containerItems.addChild(_currentItem);
			_currentItem.startDrag(false, new Rectangle(0, 0, Core.stage.stageWidth - _currentItem.width, Core.stage.stageHeight - _currentItem.height));
			if (!isAdd) {
				_currentItem.x = posX;
				_currentItem.y = posY;
			}
			setupSelectableItem(_currentItem);
			
			Core.stage.addEventListener(MouseEvent.MOUSE_UP, itemUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameMoveItemHandler);
		}
		
		protected function enableMoveItems():void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				_items[i].addEventListener(MouseEvent.MOUSE_DOWN, itemDownHandler);
				_items[i].buttonMode = true;
			}
		}
		
		protected function disableMoveItems():void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				_items[i].removeEventListener(MouseEvent.MOUSE_DOWN, itemDownHandler);
				_items[i].buttonMode = false;
			}
		}
		
		// handlers
		private function itemDownHandler(e:MouseEvent):void {
			var item:EditorItem = e.currentTarget as EditorItem;
			if (item != null) {
				setupMovebleItem(item);
			}
		}
		
		private function itemUpHandler(e:MouseEvent):void {
			Core.stage.removeEventListener(MouseEvent.MOUSE_UP, itemUpHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameMoveItemHandler);
			_currentItem.stopDrag();
			_currentItem.x = Math.floor(_currentItem.x);
			_currentItem.y = Math.floor(_currentItem.y);
			if (_currentItem.isShowedWarning) {
				for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
					if (_currentItem == _items[i]) {
						_currentItem.destroy();
						_items.splice(i, 1);
						if (_currentItem.parent != null) {
							_currentItem.parent.removeChild(_currentItem);
						}
						_currentItem = null;
						dispatchEvent(new EditorEventAttributes(EditorEventAttributes.HIDE_ATTRIBUTES, null, true));
						break;
					}
				}
			}
			enableMoveItems();
		}
		
		private function enterFrameMoveItemHandler(e:Event):void {
			if (_currentItem.x < 0 || _currentItem.y < 0 || _currentItem.x + _currentItem.width > EditorUtils.WORLD_WITDH || _currentItem.y + _currentItem.height > EditorUtils.WORLD_HEIGHT) {
				_currentItem.showWarning();
			}else if (_currentItem.isShowedWarning) {
				_currentItem.hideWarning();
			}
		}
		
	}

}