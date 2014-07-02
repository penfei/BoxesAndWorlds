package boxesandworlds.editor.area {
	import boxesandworlds.editor.data.items.EditorPlayerData;
	import boxesandworlds.editor.data.items.EditorWorldData;
	import boxesandworlds.editor.events.EditorEventAttributes;
	import boxesandworlds.editor.items.EditorAttribute;
	import boxesandworlds.editor.items.EditorItem;
	import boxesandworlds.editor.items.EditorWorld;
	import boxesandworlds.game.data.Attribute;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaWorld extends Sprite {
		
		// ui
		private var _currentWorld:EditorWorld;
		private var _worlds:Vector.<EditorWorld>;
		
		// vars
		private var _uniqueItemId:int;
		
		public function EditorAreaWorld() {
			setup();
		}
		
		// public
		public function destroy():void {
			if (_worlds != null) {
				for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
					var world:EditorWorld = _worlds[i];
					if (world != null) {
						world.destroy();
						if (world.parent != null) {
							world.parent.removeChild(world);
						}
						world = null;
					}
				}
				_worlds = null;
			}
		}
		
		public function addWorld(id:int):void {
			unselectItem();
			if (_currentWorld != null && _currentWorld.parent != null) {
				_currentWorld.parent.removeChild(_currentWorld);
			}
			var world:EditorWorld = new EditorWorld(id);
			_worlds.push(world);
			_currentWorld = world;
			addChild(_currentWorld);
		}
		
		public function removeWorld(id:int, selectId:int):void {
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].id == id) {
					var world:EditorWorld = _worlds[i];
					world.destroy();
					if (world.parent != null) {
						world.parent.removeChild(world);
					}
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
						dispatchEvent(new EditorEventAttributes(EditorEventAttributes.HIDE_ATTRIBUTES));
						_currentWorld.visible = false;
						if (_currentWorld.parent != null) {
							_currentWorld.parent.removeChild(_currentWorld);
						}
					}
					_currentWorld = _worlds[i];
					_currentWorld.visible = true;
					addChild(_currentWorld);
					return;
				}
			}
		}
		
		public function addItem(attributes:Vector.<Attribute>):void {
			if (_currentWorld != null) {
				_currentWorld.addItem(_uniqueItemId++, attributes);
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
				var world:EditorWorld = new EditorWorld(i);
				world.setupDataFromXML(worldsData[i]);
				_worlds[i] = world;
			}
			_currentWorld = _worlds[0];
			addChild(_currentWorld);
		}
		
		// protected
		protected function setup():void {
			_uniqueItemId = EditorAreaAttributes.UNIQUE_ID_UNSELECT_ITEM + 1;
			_worlds = new Vector.<EditorWorld>();
			addWorld(0);
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
		
	}
}