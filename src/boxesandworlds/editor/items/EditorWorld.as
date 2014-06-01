package boxesandworlds.editor.items {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.events.EditorEventAttributes;
	import boxesandworlds.editor.events.EditorEventPlayer;
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
		private var _player:EditorPlayer;
		private var _items:Vector.<EditorItem>;
		private var _currentItem:EditorItem;
		private var _label:TextField;
		
		// vars
		private var _id:int;
		
		public function EditorWorld(id:int) {
			_id = id;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		public function get items():Vector.<EditorItem> { return _items; }
		
		public function get player():EditorPlayer { return _player; }
		
		// public
		public function destroy():void {
			
		}
		
		public function addItem(id:String, uniqueItemId:int, attributes:Vector.<Attribute>):void {
			disableMoveItems();
			
			var item:EditorItem = new EditorItem(id, uniqueItemId, attributes);
			_items.push(item);
			setupMovebleItem(item, true);
		}
		
		public function addPlayer():void {
			setupMoveblePlayer();
		}
		
		public function removePlayer():void {
			if (_player != null) {
				_player.removeEventListener(MouseEvent.MOUSE_DOWN, playerDownHandler);
				_player.destroy();
				if (_player.parent != null) {
					_player.parent.removeChild(_player);
				}
				_player = null;
			}
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
		
		public function removeItem(index:int):void {
			var item:EditorItem = _items[index];
			item.destroy();
			_items.splice(index, 1);
			if (item.parent != null) {
				item.parent.removeChild(item);
			}
			item = null;
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
		
		protected function setupMoveblePlayer():void {
			if (_player == null) {
				_player = new EditorPlayer();
				_player.x = Core.stage.mouseX - _player.width / 2;
				_player.y = Core.stage.mouseY - _player.height / 2;
				_player.buttonMode = true;
				_player.addEventListener(MouseEvent.MOUSE_DOWN, playerDownHandler);
			}
			_containerItems.addChild(_player);
			_player.startDrag(false, new Rectangle(0, 0, Core.stage.stageWidth - _player.width, Core.stage.stageHeight - _player.height));
			
			Core.stage.addEventListener(MouseEvent.MOUSE_UP, playerUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameMovePlayerHandler);
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
						removeItem(i);
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
		
		private function playerDownHandler(e:MouseEvent):void {
			setupMoveblePlayer();
		}
		
		private function playerUpHandler(e:MouseEvent):void {
			Core.stage.removeEventListener(MouseEvent.MOUSE_UP, playerUpHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameMovePlayerHandler);
			_player.stopDrag();
			_player.x = Math.floor(_player.x);
			_player.y = Math.floor(_player.y);
			if (_player.isShowedWarning) {
				removePlayer();
				dispatchEvent(new EditorEventPlayer(EditorEventPlayer.PLAYER_NOT_SETUP, true));
			}
		}
		
		private function enterFrameMovePlayerHandler(e:Event):void {
			if (_player.x < 0 || _player.y < 0 || _player.x + _player.width > EditorUtils.WORLD_WITDH || _player.y + _player.height > EditorUtils.WORLD_HEIGHT) {
				_player.showWarning();
			}else if (_player.isShowedWarning) {
				_player.hideWarning();
			}
		}
		
	}

}