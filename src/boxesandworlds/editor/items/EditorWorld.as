package boxesandworlds.editor.items {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.area.EditorAreaWorld;
	import boxesandworlds.editor.data.items.EditorWorldData;
	import boxesandworlds.editor.events.EditorEventPlayer;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.gui.page.EditorPage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import nape.geom.Vec2;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorWorld extends EventDispatcher{
		
		// ui
		private var _editorPage:EditorPage;
		private var _areaWorld:EditorAreaWorld;
		private var _player:EditorPlayer;
		private var _items:Vector.<EditorItem>;
		private var _currentItem:EditorItem;
		
		// vars
		private var _id:int;
		private var _startPosition:Vec2;
		
		public function EditorWorld(id:int, editorPage:EditorPage, areaWorld:EditorAreaWorld) {
			_id = id;
			_editorPage = editorPage;
			_areaWorld = areaWorld;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		public function get items():Vector.<EditorItem> { return _items; }
		
		public function get player():EditorPlayer { return _player; }
		
		// set
		public function set currentItem(value:EditorItem):void { _currentItem = value; }
		
		// public
		public function destroy():void {
			if (_items != null) {
				for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
					var item:EditorItem = _items[i];
					if (item != null) {
						item.destroy();
						if (item.parent != null) {
							item.parent.removeChild(item);
						}
						item = null;
					}
				}
				_items = null;
			}
			removePlayer();
		}
		
		public function addItem(uniqueItemId:int, attributes:Vector.<Attribute>):EditorItem {
			disableMoveItems();
			
			var item:EditorItem = new EditorItem(uniqueItemId, attributes);
			_items.push(item);
			_areaWorld.setupMovebleItem(item, true);
			return item;
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
						_editorPage.showAttributes(item);
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
		
		public function setupPositionItem(valueX:Number, valueY:Number):void {
			_currentItem.x = valueX + EditorUtils.WORLD_WITDH / 2;
			_currentItem.y = valueY + EditorUtils.WORLD_HEIGHT / 2;
			if (_currentItem.x < 0) {
				_currentItem.x = 0;
			}else if (_currentItem.x + _currentItem.width > EditorUtils.WORLD_WITDH) {
				_currentItem.x = EditorUtils.WORLD_WITDH - _currentItem.width;
			}
			if (_currentItem.y < 0) {
				_currentItem.y = 0;
			}else if (_currentItem.y + _currentItem.height > EditorUtils.WORLD_HEIGHT) {
				_currentItem.y = EditorUtils.WORLD_HEIGHT - _currentItem.height;
			}
		}
		
		public function setupDataFromXML(worldData:EditorWorldData):void {
			_id = int(worldData.id);
			var len:uint = worldData.itemsData.length;
			_items.length = len;
			for (var i:uint = 0; i < len; ++i) {
				var attributes:Vector.<Attribute> = EditorUtils.createAttributesFromXML(worldData.itemsData[i]);
				
				var item:EditorItem = new EditorItem(0, attributes);
				item.x = 0;
				item.y = 0;
				_items[i] = item;
			}
			
			enableMoveItems();
		}
		
		public function removeChildItems():void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				if (_items[i] != null && _items[i].parent != null) {
					_items[i].parent.removeChild(_items[i]);
				}
			}
		}
		
		public function enableMoveItems():void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				_items[i].addEventListener(MouseEvent.MOUSE_DOWN, itemDownHandler);
				_items[i].buttonMode = true;
			}
		}
		
		public function savePositionStartInAttribute():void {
			if (_currentItem != null) {
				_startPosition.x = _currentItem.x - EditorUtils.WORLD_WITDH / 2;
				_startPosition.y = _currentItem.y - EditorUtils.WORLD_HEIGHT / 2;
				_currentItem.setupAttribute("start", _startPosition);
			}
		}
		
		// protected
		protected function setup():void {
			_items = new Vector.<EditorItem>();
			_startPosition = new Vec2();
			Core.stage.addEventListener(MouseEvent.MOUSE_UP, savePositionStartInAttributeHandler);
		}
		
		protected function setupMoveblePlayer():void {
			if (_player == null) {
				_player = new EditorPlayer();
				_player.x = Core.stage.mouseX - _player.width / 2;
				_player.y = Core.stage.mouseY - _player.height / 2;
				_player.buttonMode = true;
				_player.addEventListener(MouseEvent.MOUSE_DOWN, playerDownHandler);
			}
			_player.startDrag(false, new Rectangle(0, 0, Core.stage.stageWidth - _player.width, Core.stage.stageHeight - _player.height));
			
			Core.stage.addEventListener(MouseEvent.MOUSE_UP, playerUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameMovePlayerHandler);
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
				_areaWorld.setupMovebleItem(item);
			}
		}
		
		private function playerDownHandler(e:MouseEvent):void {
			_editorPage.hideAttributes();
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
		
		private function savePositionStartInAttributeHandler(e:MouseEvent):void {
			savePositionStartInAttribute();
		}
		
	}
}