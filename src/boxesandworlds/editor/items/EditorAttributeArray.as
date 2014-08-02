package boxesandworlds.editor.items {
	import boxesandworlds.editor.events.EditorEventChangeContainerItem;
	import boxesandworlds.editor.events.EditorEventChangeViewItem;
	import boxesandworlds.editor.items.items_array.EditorItemArray;
	import boxesandworlds.editor.items.items_array.EditorItemArrayBool;
	import boxesandworlds.editor.items.items_array.EditorItemArrayNumber;
	import boxesandworlds.editor.items.items_array.EditorItemArrayString;
	import boxesandworlds.editor.items.items_array.EditorItemArrayUrl;
	import boxesandworlds.editor.items.items_array.EditorItemArrayVec2;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import editor.EditorAttributeArrayUI;
	import flash.display.MovieClip;
	import flash.events.Event;
	import nape.geom.Vec2;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAttributeArray extends MovieClip {
		
		// const
		static public const ATTRIBUTE_ARRAY_UPDATE:String = "editorEventAttributeArrayUpdate";
		private const ATTRIBUTE_ARRAY_REMOVE_ITEM:String = "editorEventAttributeArrayRemoveItem";
		private const ATTRIBUTE_ARRAY_ADD_ITEM:String = "editorEventAttributeArrayAddItem";
		
		private const ITEM_HEIGHT:Number = 25;
		
		// ui
		private var _ui:EditorAttributeArrayUI;
		private var _values:Vector.<EditorItemArray>;
		
		// vars
		private var _type:String;
		private var _nameAttribute:String;
		private var _value:Array;
		private var _defaultValue:Array;
		private var _id:int;// индекс в массиве атрибутов _mcAttributes в его родителе EditorAttribute и EditorItem
		private var _isContainers:Boolean;
		
		public function EditorAttributeArray(type:String, nameAttribute:String, value:*, defaultValue:*, id:int) {
			_type = type;
			_nameAttribute = nameAttribute;
			var len:uint = value.length;
			_value = [];
			_value.length = len;
			for (var i:uint = 0; i < len; ++i) {
				_value[i] = value[i];
			}
			_defaultValue = defaultValue;
			_id = id;
			setup();
		}
		
		// get
		override public function get height():Number { 
			return ITEM_HEIGHT + _values.length * ITEM_HEIGHT; 
		}
		
		public function get valueXML():String {
			var value:String = "";
			for (var i:int = 0, len:uint = _values.length; i < len; ++i) {
				value += "<value>" + _values[i].valueXML + "</value>";
			}
			return value;
		}
		
		public function get isChanged():Boolean {
			var isChanged:Boolean = false;
			if (_defaultValue.length != _values.length) {
				isChanged = true;
			}else {
				isChanged = !isSameValuesWithoutOrder();
			}
			return isChanged;
		}
		
		public function get size():int { return _values.length; }
		
		public function get values():Vector.<EditorItemArray> { return _values; }
		
		// public
		public function addField():void {
			doAddItem();
			dispatchEvent(new Event(ATTRIBUTE_ARRAY_UPDATE, true));
		}
		
		public function removeField(index:int):void {
			doRemoveItem(index);
			dispatchEvent(new Event(ATTRIBUTE_ARRAY_UPDATE, true));
		}
		
		public function getContainerIdByIndex(index:int):int {
			return int(_values[index].value);
		}
		
		public function setupListenersForContainers():void {
			_isContainers = true;
			for (var i:uint = 0, len:uint = _values.length; i < len; ++i) {
				(_values[i] as EditorItemArrayNumber).setupListenersForContainers();
			}
		}
		
		// protected
		protected function setup():void {
			var len:uint = _value.length;
			_ui = new EditorAttributeArrayUI;
			addChild(_ui);
			_ui.addEventListener(ATTRIBUTE_ARRAY_ADD_ITEM, addItemHandler);
			
			if (_type == Attribute.NUMBER || _type == Attribute.STRING || _type == Attribute.URL) {
				for (var j:uint = 0, lenj:uint = _defaultValue.length; j < lenj; ++j) {
					_defaultValue[j] = EditorUtils.cutSideSpaces(String(_defaultValue[j]));
				}
			}
			
			_values = new Vector.<EditorItemArray>();
			_values.length = len;
			for (var i:int = 0; i < len; ++i) {
				var item:EditorItemArray = createItem(i);
				if (_isContainers) {
					(item as EditorItemArrayNumber).setupListenersForContainers();
				}
				item.y = ITEM_HEIGHT + ITEM_HEIGHT * i;
				_values[i] = item;
				addChild(item);
				item.addEventListener(ATTRIBUTE_ARRAY_REMOVE_ITEM, removeItemHandler);
			}
			
			updateHeight();
			
			if (_nameAttribute == EditorAttribute.NAME_ATTRIBUTE_VIEWS) {
				for (var k:uint = 0, lenk:uint = _values.length; k < lenk; ++k) {
					var itemUrl:EditorItemArrayUrl = _values[k] as EditorItemArrayUrl;
					if (itemUrl != null) {
						itemUrl.changeUrl();
					}
				}
			}
		}
		
		protected function updateHeight():void {
			var len:uint = _values.length;
			var h:Number = 23 + ITEM_HEIGHT * len;
			_ui.bg.mcCenter.height = h;
			_ui.bg.mcCenter.y = 1;
			_ui.bg.lineLeft.height = _ui.bg.lineRight.height = h + 2;
			_ui.bg.lineLeft.y = _ui.bg.lineRight.y = 0;
			_ui.bg.mcDown.y = _ui.bg.mcCenter.y + _ui.bg.mcCenter.height;
			_ui.labelName.text = _nameAttribute + " [" + String(len) + "]:";
			for (var j:uint = 0, lenj:uint = _values.length; j < lenj; ++j) {
				_values[j].y = ITEM_HEIGHT + ITEM_HEIGHT * j;
			}
		}
		
		protected function createItem(index:int = -1):EditorItemArray {
			var item:EditorItemArray;
			switch(_type) {
				case Attribute.BOOL:
					item = new EditorItemArrayBool(index == -1 ? EditorItemArrayBool.DEFAULT_VALUE : String(_defaultValue[index]));
					break;
					
				case Attribute.NUMBER:
					item = new EditorItemArrayNumber(index == -1 ? EditorItemArrayNumber.DEFAULT_VALUE : String(_defaultValue[index]), _values.length);
					break;
					
				case Attribute.STRING:
					item = new EditorItemArrayString(index == -1 ? EditorItemArrayString.DEFAULT_VALUE : String(_defaultValue[index]));
					break;
					
				case Attribute.URL:
					item = new EditorItemArrayUrl(index == -1 ? EditorItemArrayUrl.DEFAULT_VALUE : String(_defaultValue[index]), _values.length);
					break;
					
				case Attribute.VEC2:
					item = new EditorItemArrayVec2(index == -1 ? EditorItemArrayVec2.DEFAULT_VALUE : _defaultValue[index]);
					break;
			}
			return item;
		}
		
		protected function isSameValuesWithoutOrder():Boolean {
			for (var i:uint = 0, len:uint = _defaultValue.length; i < len; ++i) {
				switch(_type) {
					case Attribute.BOOL:
					case Attribute.NUMBER:
					case Attribute.STRING:
					case Attribute.URL:
						if (String(_defaultValue[i]) != _values[i].value) {
							return false;
						}
						break;
						
					case Attribute.VEC2:
						var values:Array = _values[i].value.split(" ");
						if (String(Vec2(_defaultValue[i]).x) != values[0] || String(Vec2(_defaultValue[i]).y) != values[1]) {
							return false;
						}
						break; 
				}
			}
			return true;
		}
		
		protected function doAddItem():void {
			var item:EditorItemArray = createItem();
			if (_isContainers) {
				(item as EditorItemArrayNumber).setupListenersForContainers();
			}
			_values.push(item);
			addChild(item);
			item.addEventListener(ATTRIBUTE_ARRAY_REMOVE_ITEM, removeItemHandler);
			updateHeight();
		}
		
		protected function doRemoveItem(index:int):void {
			var item:EditorItemArray = _values[index];
			_values.splice(index, 1);
			if (contains(item)) {
				removeChild(item);
				item.removeEventListener(ATTRIBUTE_ARRAY_REMOVE_ITEM, removeItemHandler);
				item = null;
			}
			updateHeight();
		}
		
		// handlers
		private function removeItemHandler(e:Event):void {
			var item:EditorItemArray = e.currentTarget as EditorItemArray;
			if (item != null) {
				for (var i:int = 0, len:uint = _values.length; i < len; ++i) {
					if (item == _values[i]) {
						doRemoveItem(i);
						if (_nameAttribute == EditorAttribute.NAME_ATTRIBUTE_VIEWS) {
							dispatchEvent(new EditorEventChangeViewItem(EditorEventChangeViewItem.REMOVE_FIELD_VIEW, "", i, null, true));
						}else if (_nameAttribute == EditorAttribute.NAME_ATTRIBUTE_CONTAINERS) {
							dispatchEvent(new EditorEventChangeContainerItem(EditorEventChangeContainerItem.REMOVE_FIELD_CONTAINER, i, int(item.value), true));
						}
						dispatchEvent(new Event(ATTRIBUTE_ARRAY_UPDATE, true));
						break;
					}
				}
			}
		}
		
		private function addItemHandler(e:Event):void {
			doAddItem();
			dispatchEvent(new Event(ATTRIBUTE_ARRAY_UPDATE, true));
			if (_nameAttribute == EditorAttribute.NAME_ATTRIBUTE_VIEWS) {
				dispatchEvent(new EditorEventChangeViewItem(EditorEventChangeViewItem.ADD_FIELD_VIEW, "", -1, null, true));
			}else if (_nameAttribute == EditorAttribute.NAME_ATTRIBUTE_CONTAINERS) {
				dispatchEvent(new EditorEventChangeContainerItem(EditorEventChangeContainerItem.ADD_FIELD_CONTAINER, -1, -1, true));
			}
		}
		
	}
}