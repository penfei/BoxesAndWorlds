package boxesandworlds.editor.items {
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
		private var _id:int;
		
		public function EditorAttributeArray(type:String, nameAttribute:String, value:*, defaultValue:*, id:int) {
			_type = type;
			_nameAttribute = nameAttribute;
			_value = value as Array;
			_defaultValue = defaultValue;
			_id = id;
			
			//_type = Attribute.VEC2;
			//_defaultValue = [new Vec2(1,2), new Vec2(123, 200)];
			//_value = [new Vec2(1,2), new Vec2(123, 200)];
			
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
				item.y = ITEM_HEIGHT + ITEM_HEIGHT * i;
				_values[i] = item;
				addChild(item);
				item.addEventListener(ATTRIBUTE_ARRAY_REMOVE_ITEM, removeItemHandler);
			}
			
			updateHeight();
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
		}
		
		protected function createItem(index:int = -1):EditorItemArray {
			var item:EditorItemArray;
			switch(_type) {
				case Attribute.BOOL:
					item = new EditorItemArrayBool(index == -1 ? EditorItemArrayBool.DEFAULT_VALUE : String(_defaultValue[index]));
					break;
					
				case Attribute.NUMBER:
					item = new EditorItemArrayNumber(index == -1 ? EditorItemArrayNumber.DEFAULT_VALUE : String(_defaultValue[index]));
					break;
					
				case Attribute.STRING:
					item = new EditorItemArrayString(index == -1 ? EditorItemArrayString.DEFAULT_VALUE : String(_defaultValue[index]));
					break;
					
				case Attribute.URL:
					item = new EditorItemArrayUrl(index == -1 ? EditorItemArrayUrl.DEFAULT_VALUE : String(_defaultValue[index]));
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
		
		// handlers
		private function removeItemHandler(e:Event):void {
			var item:EditorItemArray = e.currentTarget as EditorItemArray;
			if (item != null) {
				for (var i:uint = 0, len:uint = _values.length; i < len; ++i) {
					if (item == _values[i]) {
						_values.splice(i, 1);
						if (contains(item)) {
							removeChild(item);
							item.removeEventListener(ATTRIBUTE_ARRAY_REMOVE_ITEM, removeItemHandler);
							item = null;
						}
						for (var j:uint = i, lenj:uint = _values.length; j < lenj; ++j) {
							_values[j].y = ITEM_HEIGHT + ITEM_HEIGHT * j;
						}
						updateHeight();
						dispatchEvent(new Event(ATTRIBUTE_ARRAY_UPDATE, true));
						break;
					}
				}
			}
		}
		
		private function addItemHandler(e:Event):void {
			var item:EditorItemArray = createItem();
			item.y = ITEM_HEIGHT + ITEM_HEIGHT * _values.length;
			_values.push(item);
			addChild(item);
			item.addEventListener(ATTRIBUTE_ARRAY_REMOVE_ITEM, removeItemHandler);
			updateHeight();
			dispatchEvent(new Event(ATTRIBUTE_ARRAY_UPDATE, true));
		}
		
	}

}