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
						item = null;
					}
				}
				_items = null;
			}
			removePlayer();
		}
		
		public function addItem(uniqueItemId:int, attributes:Vector.<Attribute>):EditorItem {
			disableMoveItems();
			var item:EditorItem = new EditorItem(uniqueItemId, _items.length, attributes);
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
			item = null;
			_items.splice(index, 1);
			_currentItem = null;
		}
		
		public function setupPositionItem(valueX:Number, valueY:Number):void {
			_currentItem.setupPosition(valueX + EditorUtils.WORLD_WITDH / 2, valueY + EditorUtils.WORLD_HEIGHT / 2);
			if (_currentItem.viewDefault.x < 0) {
				_currentItem.setupPosition(0, 0, true, false);
			}else if (_currentItem.viewDefault.x + _currentItem.width > EditorUtils.WORLD_WITDH) {
				_currentItem.setupPosition(EditorUtils.WORLD_WITDH - _currentItem.width, 0, true, false);
			}
			if (_currentItem.viewDefault.y < 0) {
				_currentItem.setupPosition(0, 0, false, true);
			}else if (_currentItem.viewDefault.y + _currentItem.height > EditorUtils.WORLD_HEIGHT) {
				_currentItem.setupPosition(0, EditorUtils.WORLD_HEIGHT - _currentItem.height, false, true);
			}
		}
		
		public function setupDataFromXML(worldData:EditorWorldData):void {
			_id = int(worldData.id);
			var len:uint = worldData.itemsData.length;
			_items.length = len;
			for (var i:uint = 0; i < len; ++i) {
				var attributes:Vector.<Attribute> = EditorUtils.createAttributesFromXML(worldData.itemsData[i]);
				
				var item:EditorItem = new EditorItem(0, i, attributes);
				item.setupPosition(0, 0);
				_items[i] = item;
			}
			
			enableMoveItems();
		}
		
		public function removeChildItems():void {
			if (_player != null && _player.parent != null) {
				_player.parent.removeChild(_player);
			}
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				if (_items[i] != null) {
					if (_items[i].viewDefault != null && _items[i].viewDefault.parent != null) {
						_items[i].viewDefault.parent.removeChild(_items[i].viewDefault);
					}
					for (var j:uint = 0, lenj:uint = _items[i].views.length; j < lenj; ++j) {
						var view:EditorItemView = _items[i].views[j];
						if (view != null && view.parent != null) {
							view.parent.removeChild(view);
						}
					}
				}
			}
		}
		
		public function enableMoveItems():void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				_items[i].viewDefault.addEventListener(MouseEvent.MOUSE_DOWN, itemDownHandler);
				_items[i].viewDefault.buttonMode = true;
			}
		}
		
		public function savePositionStartInAttribute():void {
			if (_currentItem != null) {
				_startPosition.x = _currentItem.viewDefault.x - EditorUtils.WORLD_WITDH / 2;
				_startPosition.y = _currentItem.viewDefault.y - EditorUtils.WORLD_HEIGHT / 2;
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
				dispatchEvent(new Event(EditorPlayer.ADD_PLAYER));
			}
			_player.startDrag(false, new Rectangle(0, 0, Core.stage.stageWidth - _player.width, Core.stage.stageHeight - _player.height));
		}
		
		protected function disableMoveItems():void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				_items[i].viewDefault.removeEventListener(MouseEvent.MOUSE_DOWN, itemDownHandler);
				_items[i].viewDefault.buttonMode = false;
			}
		}
		
		// handlers
		private function itemDownHandler(e:MouseEvent):void {
			var item:EditorItemViewDefault = e.currentTarget as EditorItemViewDefault;
			if (item != null) {
				_areaWorld.setupMovebleItem(item.editorItem);
			}
		}
		
		private function playerDownHandler(e:MouseEvent):void {
			_editorPage.hideAttributes();
			setupMoveblePlayer();
			_areaWorld.setupMoveblePlayer();
		}
		
		private function savePositionStartInAttributeHandler(e:MouseEvent):void {
			savePositionStartInAttribute();
		}
		
	}
}