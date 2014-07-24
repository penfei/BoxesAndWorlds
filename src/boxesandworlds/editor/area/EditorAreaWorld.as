package boxesandworlds.editor.area {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.data.items.EditorPlayerData;
	import boxesandworlds.editor.data.items.EditorWorldData;
	import boxesandworlds.editor.items.EditorAttribute;
	import boxesandworlds.editor.items.EditorItem;
	import boxesandworlds.editor.items.EditorWorld;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.gui.page.EditorPage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
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
			_worlds.push(world);
			_currentWorld = world;
		}
		
		public function removeWorld(id:int, selectId:int):void {
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].id == id) {
					var world:EditorWorld = _worlds[i];
					world.destroy();
					world = null;
					_worlds.splice(i, 1);
					selectWorld(selectId);
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
				_layers[0].addChild(item);
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
				_currentItem.x = Core.stage.mouseX - _currentItem.width / 2;
				_currentItem.y = Core.stage.mouseY - _currentItem.height / 2;
			}
			_currentItem.startDrag(false, new Rectangle(0, 0, Core.stage.stageWidth - _currentItem.width, Core.stage.stageHeight - _currentItem.height));
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
				var world:EditorWorld = new EditorWorld(i, _editorPage, this);
				world.setupDataFromXML(worldsData[i]);
				_worlds[i] = world;
			}
			_currentWorld = _worlds[0];
			addChildItems(_currentWorld);
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
			for (var i:uint = 0, len:uint = world.items.length; i < len; ++i) {
				_layers[0].addChild(world.items[i]);
			}
		}
		
		protected function getPlayerXML():String {
			var xml:String = "<player";
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].player != null) {
					xml += " worldId='" + String(_worlds[i].id + 1) + "' x='" + String(_worlds[i].player.x) + "' y='" + String(_worlds[i].player.y) + "'";
					break;
				}
			}
			xml += "></player>"
			return xml;
		}
		
		protected function getWorldXML(world:EditorWorld):String {
			var xml:String = "<world id='" + String( world.id + 1 ) + "'>";
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
			var xml:String = "<" + attribute.nameAttribute + " attributeName='" + attribute.nameAttribute + "'" + " type='" + attribute.type + "'";
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
		
		// handlers
		private function itemUpHandler(e:MouseEvent):void {
			Core.stage.removeEventListener(MouseEvent.MOUSE_UP, itemUpHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameMoveItemHandler);
			_currentItem.stopDrag();
			_currentItem.x = Math.floor(_currentItem.x);
			_currentItem.y = Math.floor(_currentItem.y);
			if (_currentItem.isShowedWarning) {
				for (var i:uint = 0, len:uint = _currentWorld.items.length; i < len; ++i) {
					if (_currentItem == _currentWorld.items[i]) {
						_currentWorld.removeItem(i);
						_editorPage.hideAttributes();
						break;
					}
				}
			}
			_currentWorld.enableMoveItems();
		}
		
		private function enterFrameMoveItemHandler(e:Event):void {
			if (_currentItem.x < 0 || _currentItem.y < 0 || _currentItem.x + _currentItem.width > EditorUtils.WORLD_WITDH || _currentItem.y + _currentItem.height > EditorUtils.WORLD_HEIGHT) {
				_currentItem.showWarning();
			}else if (_currentItem.isShowedWarning) {
				_currentItem.hideWarning();
			}
			_currentWorld.savePositionStartInAttribute();
		}
		
	}
}