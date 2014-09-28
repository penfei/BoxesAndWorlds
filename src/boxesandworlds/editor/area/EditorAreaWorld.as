package boxesandworlds.editor.area {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.data.items.EditorPlayerData;
	import boxesandworlds.editor.data.items.EditorWorldData;
	import boxesandworlds.editor.events.EditorEventPlayer;
	import boxesandworlds.editor.events.EditorEventUpdateContainerItem;
	import boxesandworlds.editor.events.EditorEventUpdateViewItem;
	import boxesandworlds.editor.items.EditorAttribute;
	import boxesandworlds.editor.items.EditorItem;
	import boxesandworlds.editor.items.EditorItemView;
	import boxesandworlds.editor.items.EditorPlayer;
	import boxesandworlds.editor.items.EditorWorld;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.gui.page.EditorPage;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaWorld extends Sprite {
		
		// ui
		private var _editorPage:EditorPage;
		
		private var _layers:Vector.<Sprite>;
		private var _canvasLayers:Sprite;
		private var _canvasTop:Sprite;
		
		private var _worlds:Vector.<EditorWorld>;
		private var _currentWorld:EditorWorld;
		private var _currentItem:EditorItem;
		
		// vars
		private var _uniqueItemId:int;
		
		public function EditorAreaWorld(editorPage:EditorPage) {
			_editorPage = editorPage;
			setup();
		}
		
		// public
		public function destroy():void {
			if (_worlds != null) {
				for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
					var world:EditorWorld = _worlds[i];
					if (world != null) {
						world.destroy();
						world = null;
					}
				}
				_worlds = null;
			}
		}
		
		public function addWorld(id:int):void {
			unselectItem();
			if (_currentWorld != null) {
				_currentWorld.removeChildItems();
			}
			var world:EditorWorld = new EditorWorld(id, _editorPage, this);
			world.addEventListener(EditorPlayer.ADD_PLAYER, playerAddedHandler);
			_worlds.push(world);
			_currentWorld = world;
		}
		
		public function removeWorld(removeId:int, nextId:int):void {
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].id == removeId) {
					var world:EditorWorld = _worlds[i];
					if (world.player != null) {
						world.removePlayer();
						dispatchEvent(new EditorEventPlayer(EditorEventPlayer.PLAYER_NOT_SETUP));
					}
					world.destroy();
					world = null;
					_worlds[i] = null;
					_worlds.splice(i, 1);
					_currentWorld = null;
					selectWorld(nextId);
					return;
				}
			}
		}
		
		public function selectWorld(id:int):void {
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].id == id) {
					if (_currentWorld != null) {
						unselectItem();
						_editorPage.hideAttributes();
						_currentWorld.removeChildItems();
					}
					_currentWorld = _worlds[i];
					addChildItems(_currentWorld);
					return;
				}
			}
		}
		
		public function addItem(attributes:Vector.<Attribute>):void {
			if (_currentWorld != null) {
				var item:EditorItem = _currentWorld.addItem(_uniqueItemId++, attributes);
				item.addEventListener(EditorEventUpdateViewItem.UPDATE_VIEW, updateViewItemHandler);
				item.addEventListener(EditorEventUpdateContainerItem.UPDATE_CONTAINER, updateContainerItemHandler);
				addChildItem(item);
			}
		}
		
		public function unselectItem():void {
			if (_currentWorld != null) {
				_currentWorld.setupSelectableItem();
			}
		}
		
		public function removeAllItems():void {
			if (_currentWorld != null) {
				for (var i:int = _currentWorld.items.length - 1; i >= 0; --i) {
					_currentWorld.removeItem(i);
				}
			}
		}
		
		public function addPlayer():void {
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				_worlds[i].removePlayer();
			}
			_currentWorld.addPlayer();
			setupMoveblePlayer();
		}
		
		public function setupMoveblePlayer():void {
			Core.stage.addEventListener(MouseEvent.MOUSE_UP, playerUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameMovePlayerHandler);
		}
		
		public function setupPositionItem(valueX:Number, valueY:Number):void {
			_currentWorld.setupPositionItem(valueX, valueY);
		}
		
		public function setupLayers(layers:Vector.<Sprite>):void {
			if (_layers != null) {
				for (var i:uint = 0, len:uint = _layers.length; i < len; ++i) {
					if (_layers[i] != null) {
						_layers[i].removeChildren();
						if (_layers[i].parent != null) {
							_layers[i].parent.removeChild(_layers[i]);
						}
						_layers[i] = null;
					}
				}
			}
			
			_layers = layers;
			for (var j:uint = 0, lenj:uint = _layers.length; j < lenj; ++j) {
				_canvasLayers.addChild(_layers[j]);
			}
			for (var k:uint = 0, lenk:uint = _worlds.length; k < lenk; ++k) {
				addChildItems(_worlds[i]);
			}
		}
		
		public function setupMovebleItem(item:EditorItem, isAdd:Boolean = false):void {
			_currentItem = item;
			_currentWorld.currentItem = item;
			
			if (isAdd) {
				_currentItem.setupPosition(Core.stage.mouseX - _currentItem.width / 2 - _editorPage.containerWorld.x, Core.stage.mouseY - _currentItem.height / 2 - _editorPage.containerWorld.y);
			}
			startDragCurrentItem();
			_currentWorld.setupSelectableItem(_currentItem);
			
			Core.stage.addEventListener(MouseEvent.MOUSE_UP, itemUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameMoveItemHandler);
		}
		
		public function getWorldsAndPlayerXML(xml:XML):XML {
			xml.appendChild(XML(getPlayerXML()));
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				xml.appendChild(XML(getWorldXML(_worlds[i])));
			}
			return xml;
		}
		
		public function setupDataFromXML(playerData:EditorPlayerData, worldsData:Vector.<EditorWorldData>):void {
			destroy();
			_uniqueItemId = EditorAreaAttributes.UNIQUE_ID_UNSELECT_ITEM + 1;
			var len:uint = worldsData.length;
			_worlds = new Vector.<EditorWorld>();
			_worlds.length = len;
			for (var i:int = 0; i < len; ++i) {
				var world:EditorWorld = new EditorWorld(int(worldsData[i].id), _editorPage, this);
				world.addEventListener(EditorPlayer.ADD_PLAYER, playerAddedHandler);
				world.setupDataFromXML(worldsData[i]);
				_worlds[i] = world;
				for (var j:uint = 0, lenj:uint = world.items.length; j < lenj; ++j) {
					world.items[j].addEventListener(EditorEventUpdateViewItem.UPDATE_VIEW, updateViewItemHandler);
					world.items[j].addEventListener(EditorEventUpdateContainerItem.UPDATE_CONTAINER, updateContainerItemHandler);
				}
				_currentWorld = world;
				if (playerData.playerWorldId != "" && int(playerData.playerWorldId) == world.id) {
					world.addPlayer(false, false, Number(playerData.playerPositionX), Number(playerData.playerPositionY));
					doAddPlayer(world.player);
					_editorPage.disablePlayer();
				}
			}
			_currentWorld = _worlds[0];
			addChildItems(_currentWorld);
		}
		
		public function setupStateRemoveItemByKey(isEnable:Boolean):void {
			if (isEnable) {
				Core.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownItemHandler);
			}else {
				Core.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownItemHandler);
			}
		}
		
		// protected
		protected function setup():void {
			_canvasLayers = new Sprite();
			addChild(_canvasLayers);
			
			_canvasTop = new Sprite();
			addChild(_canvasTop);
			
			_uniqueItemId = EditorAreaAttributes.UNIQUE_ID_UNSELECT_ITEM + 1;
			_worlds = new Vector.<EditorWorld>();
			addWorld(0);
		}
		
		protected function addChildItems(world:EditorWorld):void {
			if (world.player != null) {
				_canvasTop.addChild(world.player);
			}
			var items:Vector.<EditorItem> = world.items;
			for (var i:uint = 0, len:uint = items.length; i < len; ++i) {
				addChildItem(items[i]);
			}
		}
		
		protected function addChildItem(item:EditorItem):void {
			_canvasTop.addChild(item.viewDefault);
			for (var i:uint = 0, len:uint = item.views.length; i < len; ++i) {
				var view:EditorItemView = item.views[i];
				if (view != null) {
					_layers[view.containerId].addChild(view);
				}
			}
		}
		
		protected function doItemUpHandler(isRemoveItem:Boolean = false):void {
			Core.stage.removeEventListener(MouseEvent.MOUSE_UP, itemUpHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameMoveItemHandler);
			stopDragCurrentItem();
			_currentItem.setupPosition(Math.floor(_currentItem.viewDefault.x), Math.floor(_currentItem.viewDefault.y));
			if (_currentItem.isShowedWarning || isRemoveItem) {
				removeItem();
			}
			_currentWorld.enableMoveItems();
		}
		
		protected function removeItem():void {
			for (var i:uint = 0, len:uint = _currentWorld.items.length; i < len; ++i) {
				if (_currentItem == _currentWorld.items[i]) {
					_currentWorld.removeItem(i);
					_currentItem = null;
					_editorPage.hideAttributes();
					break;
				}
			}
		}
		
		protected function getPlayerXML():String {
			var xml:String = "<player";
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].player != null) {
					xml += " worldId='" + String(_worlds[i].id) + "' x='" + String(_worlds[i].player.x) + "' y='" + String(_worlds[i].player.y) + "'";
					break;
				}
			}
			xml += "></player>"
			return xml;
		}
		
		protected function getWorldXML(world:EditorWorld):String {
			var xml:String = "<world id='" + String( world.id ) + "'>";
			for (var i:uint = 0, len:uint = world.items.length; i < len; ++i) {
				xml += getItemXML(world.items[i]);
			}
			xml += "</world>";
			return xml;
		}
		
		protected function getItemXML(item:EditorItem):String {
			var xml:String = "<" + item.nameItem + " itemName='" + item.nameItem + "'" + ">";
			for (var i:uint = 0, len:uint = item.mcAttributes.length; i < len; ++i) {
				if (item.mcAttributes[i].isChanged) {
					xml += getAttributeXML(item.mcAttributes[i]);
				}
			}
			xml += "</" + item.nameItem + ">";
			return xml;
		}
		
		protected function getAttributeXML(attribute:EditorAttribute):String {
			//var xml:String = "<" + attribute.nameAttribute + " attributeName='" + attribute.nameAttribute + "'" + " type='" + attribute.type + "'";
			var xml:String = "<" + attribute.nameAttribute + " type='" + attribute.type + "'";
			if (attribute.isArray) {
				xml += " isArray='true'>";
				xml += attribute.valueXML;
			}else if (attribute.isEnum) {
				xml += " isEnum='true' value='" + attribute.valueEnum + "'>";
				xml += attribute.valueXML;
			}else {
				xml += " " + attribute.valueXML + ">";
			}
			xml += "</" + attribute.nameAttribute + ">";
			return xml;
		}
		
		protected function startDragCurrentItem():void {
			//_currentItem.viewDefault.startDrag(false, new Rectangle(0, 0, Core.stage.stageWidth - _currentItem.width, Core.stage.stageHeight - _currentItem.height));
			_currentItem.viewDefault.startDrag(false);
			addEventListener(Event.ENTER_FRAME, updateItemViewsPositionsHandler);
		}
		
		protected function stopDragCurrentItem():void {
			_currentItem.viewDefault.stopDrag();
			removeEventListener(Event.ENTER_FRAME, updateItemViewsPositionsHandler);
			updateItemViewsPositionsHandler();
		}
		
		protected function doAddPlayer(player:EditorPlayer):void {
			player.x = Core.stage.mouseX - player.width / 2 - _editorPage.containerWorld.x; 
			player.y = Core.stage.mouseY - player.height / 2 - _editorPage.containerWorld.y;
			_canvasTop.addChild(player);
		}
		
		// handlers
		private function itemUpHandler(e:MouseEvent):void {
			doItemUpHandler();
		}
		
		private function keyDownItemHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.DELETE) {
				doItemUpHandler(true);
			}
		}
		
		private function enterFrameMoveItemHandler(e:Event):void {
			/*if (_currentItem.viewDefault.x < 0 || _currentItem.viewDefault.y < 0 || _currentItem.viewDefault.x + _currentItem.width > EditorUtils.WORLD_WITDH || _currentItem.viewDefault.y + _currentItem.height > EditorUtils.WORLD_HEIGHT) {
				_currentItem.showWarning();
			}else if (_currentItem.isShowedWarning) {
				_currentItem.hideWarning();
			}*/
			var p:Point = localToGlobal(new Point(_currentItem.viewDefault.x, _currentItem.viewDefault.y));
			if (p.x > EditorUtils.WORLD_WITDH) {
				_currentItem.showWarning();
			}else if (_currentItem.isShowedWarning) {
				_currentItem.hideWarning();
			}
			_currentWorld.savePositionStartInAttribute();
		}
		
		private function updateViewItemHandler(e:EditorEventUpdateViewItem):void {
			var item:EditorItem = _currentWorld.items[e.indexItem];
			var view:EditorItemView = item.views[e.idView];
			view.x = item.viewDefault.x;
			view.y = item.viewDefault.y;
			_layers[view.containerId].addChild(view);
		}
		
		private function updateContainerItemHandler(e:EditorEventUpdateContainerItem):void {
			var item:EditorItem = _currentWorld.items[e.indexItem];
			var view:EditorItemView = item.views[e.indexView];
			_layers[e.idContainer].addChild(view);
		}
		
		private function updateItemViewsPositionsHandler(e:Event = null):void {
			for (var i:uint = 0, len:uint = _currentItem.views.length; i < len; ++i) {
				_currentItem.setupPosition(_currentItem.viewDefault.x, _currentItem.viewDefault.y);
			}
		}
		
		private function playerAddedHandler(e:Event):void {
			doAddPlayer(_currentWorld.player);
		}
		
		private function playerUpHandler(e:MouseEvent):void {
			Core.stage.removeEventListener(MouseEvent.MOUSE_UP, playerUpHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameMovePlayerHandler);
			_currentWorld.player.stopDrag();
			_currentWorld.player.x = Math.floor(_currentWorld.player.x);
			_currentWorld.player.y = Math.floor(_currentWorld.player.y);
			if (_currentWorld.player.isShowedWarning) {
				_currentWorld.removePlayer();
				dispatchEvent(new EditorEventPlayer(EditorEventPlayer.PLAYER_NOT_SETUP));
			}
		}
		
		private function enterFrameMovePlayerHandler(e:Event):void {
			/*if (_currentWorld.player.x < 0 || _currentWorld.player.y < 0 || _currentWorld.player.x + _currentWorld.player.width > EditorUtils.WORLD_WITDH || _currentWorld.player.y + _currentWorld.player.height > EditorUtils.WORLD_HEIGHT) {
				_currentWorld.player.showWarning();
			}else if (_currentWorld.player.isShowedWarning) {
				_currentWorld.player.hideWarning();
			}*/
			var p:Point = localToGlobal(new Point(_currentWorld.player.x, _currentWorld.player.y));
			if (p.x + _currentWorld.player.width > EditorUtils.WORLD_WITDH) {
				_currentWorld.player.showWarning();
			}else if (_currentWorld.player.isShowedWarning) {
				_currentWorld.player.hideWarning();
			}
		}
		
	}
}