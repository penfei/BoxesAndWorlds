package boxesandworlds.editor.items {
	import boxesandworlds.editor.events.EditorEventChangeAttributeStart;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import editor.EditorAttributeBoolUI;
	import editor.EditorAttributeNumberUI;
	import editor.EditorAttributeStringUI;
	import editor.EditorAttributeUrlUI;
	import editor.EditorAttributeVec2UI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextFieldType;
	import nape.geom.Vec2;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAttribute extends Sprite {
		
		// const
		static public const NAME_ATTRIBUTE_VIEWS:String = "views";
		static public const NAME_ATTRIBUTE_CONTAINERS:String = "containerIds";
		
		// ui
		private var _ui:MovieClip;
		
		// vars
		private var _nameAttribute:String;
		private var _isEnum:Boolean;
		private var _isArray:Boolean;
		private var _type:String;
		private var _value:*;
		private var _enumValues:Array;
		
		private var _defaultValue:*;
		private var _id:int;// индекс в массиве атрибутов _mcAttributes в его родителе EditorItem
		private var _file:FileReference;
		
		public function EditorAttribute(id:int, name:String, isEnum:Boolean, isArray:Boolean, type:String = "", value:* = null, defaultValue:* = null, enumValues:Array = null) {
			_id = id;
			_nameAttribute = name;
			_isEnum = isEnum;
			_isArray = isArray;
			_type = type;
			_value = value;
			_defaultValue = defaultValue;
			_enumValues = enumValues;
			setup();
		}
		
		// get
		override public function get height():Number {
			if (_isArray) {
				return _ui.height;
			}else {
				return 25;
			}
		}
		
		public function get id():int { return _id; }
		
		public function get nameAttribute():String { return _nameAttribute; }
		
		public function get isEnum():Boolean { return _isEnum; }
		
		public function get isArray():Boolean { return _isArray; }
		
		public function get type():String { return _type; }
		
		public function get valueEnum():String { return _ui.value; }
		
		public function get valueXML():String { 
			var value:String = "value='";
			if (_isEnum) {
				value = _ui.valueXML;
			}else if (_isArray) {
				value = _ui.valueXML;
			}else {
				switch(_type) {
					case Attribute.BOOL:
						value += String(_ui.mcValue.mcCheck.visible);
						break;
						
					case Attribute.NUMBER:
					case Attribute.STRING:
					case Attribute.URL:
						value += EditorUtils.cutSideSpaces(_ui.mcValue.label.text);
						break;
						
					case Attribute.VEC2:
						value = "x='" + EditorUtils.cutSideSpaces(_ui.mcValue.value1.text) + "' y='" + EditorUtils.cutSideSpaces(_ui.mcValue.value2.text);
						break;
				}
				value += "'";
			}
			return value;
		}
		
		public function get isChanged():Boolean { 
			var isChanged:Boolean;
			if (_isEnum) {
				isChanged = String(_defaultValue) != EditorAttributeEnum(_ui).value;
			}else if (_isArray) {
				isChanged = _ui.isChanged;
			}else {
				switch(_type) {
					case Attribute.BOOL:
						isChanged = Boolean(_defaultValue) != _ui.mcValue.mcCheck.visible;
						break;
						
					case Attribute.NUMBER:
					case Attribute.STRING:
					case Attribute.URL:
						isChanged = String(_value) != EditorUtils.cutSideSpaces(_ui.mcValue.label.text);
						break;
						
					case Attribute.VEC2:
						isChanged = String(Vec2(_defaultValue).x) != EditorUtils.cutSideSpaces(_ui.mcValue.value1.text) || String(Vec2(_defaultValue).y) != EditorUtils.cutSideSpaces(_ui.mcValue.value2.text);
						break;
				}
			}
			if (_nameAttribute == "id" || _nameAttribute == "start") {
				isChanged = true;
			}
			return isChanged;
		}
		
		public function get sizeArray():int { return (_ui as EditorAttributeArray).size; }
		
		public function get ui():MovieClip { return _ui; }
		
		public function get value():* { return _value; }
		
		// public
		public function destroy():void {
			if (_ui != null) {
				if (_ui.parent != null) {
					_ui.parent.removeChild(_ui);
				}
				_ui = null;
			}
		}
		
		public function setupValue(value:*):void {
			switch(_type) {
				case Attribute.BOOL:
					_ui.mcValue.mcCheck.visible = Boolean(value);
					break;
					
				case Attribute.NUMBER:
				case Attribute.STRING:
				case Attribute.URL:
					_ui.mcValue.label.text = EditorUtils.cutSideSpaces(String(value));
					break;
					
				case Attribute.VEC2:
					var result:Vec2 = value as Vec2;
					if (result != null) {
						_ui.mcValue.value1.text = EditorUtils.cutSideSpaces(String(result.x));
						_ui.mcValue.value2.text = EditorUtils.cutSideSpaces(String(result.y));
					}
					break;
			}
		}
		
		public function addFieldArray():void {
			(_ui as EditorAttributeArray).addField();
		}
		
		public function removeFieldArray(id:int):void {
			(_ui as EditorAttributeArray).removeField(id);
		}
		
		public function setupListenersForContainers():void {
			(_ui as EditorAttributeArray).setupListenersForContainers();
		}
		
		// protected
		protected function setup():void {
			if (!_isArray && (_type == Attribute.NUMBER || _type == Attribute.STRING || _type == Attribute.URL)) {
				_defaultValue = EditorUtils.cutSideSpaces(String(_defaultValue));
			}
			
			if (_isEnum) {
				_ui = new EditorAttributeEnum(_type, _nameAttribute, _enumValues, String(_defaultValue), _id);
			}else if (_isArray) {
				_ui = new EditorAttributeArray(_type, _nameAttribute, _value, _defaultValue, _id);
			}else {
				switch(_type) {
					case Attribute.BOOL:
						_ui = new EditorAttributeBoolUI;
						_ui.labelName.text = _nameAttribute;
						_ui.mcValue.buttonMode = true;
						_ui.mcValue.addEventListener(MouseEvent.CLICK, mcValueBoolClickHandler);
						_value = String(_value) == "true" ? true : false;
						_ui.mcValue.mcCheck.visible = _value;
						break;
						
					case Attribute.NUMBER:
						_ui = new EditorAttributeNumberUI;
						_ui.labelName.text = _nameAttribute;
						_ui.mcValue.label.type = TextFieldType.INPUT;
						_ui.mcValue.label.selectable = true;
						_ui.mcValue.label.text = String(_value);
						_ui.mcValue.label.restrict = "0-9.";
						break;
						
					case Attribute.STRING:
						_ui = new EditorAttributeStringUI;
						_ui.labelName.text = _nameAttribute;
						_ui.mcValue.label.type = TextFieldType.INPUT;
						_ui.mcValue.label.selectable = true;
						_ui.mcValue.label.text = String(_value);
						break;
						
					case Attribute.URL:
						_ui = new EditorAttributeUrlUI;
						_ui.labelName.text = _nameAttribute;
						_ui.mcValue.label.type = TextFieldType.INPUT;
						_ui.mcValue.label.selectable = true;
						_ui.mcChoiceUrl.buttonMode = true;
						_ui.mcChoiceUrl.addEventListener(MouseEvent.CLICK, mcChoiceUrlClickHandler);
						_ui.mcValue.label.text = String(_value);
						break;
						
					case Attribute.VEC2:
						_ui = new EditorAttributeVec2UI;
						_ui.labelName.text = _nameAttribute;
						_ui.mcValue.key1.text = "x:";
						_ui.mcValue.key2.text = "y:";
						var value:Vec2 = _value as Vec2;
						if (value != null) {
							_ui.mcValue.value1.text = String(value.x);
							_ui.mcValue.value2.text = String(value.y);
						}
						_ui.mcValue.value1.type = TextFieldType.INPUT;
						_ui.mcValue.value1.selectable = true;
						_ui.mcValue.value2.type = TextFieldType.INPUT;
						_ui.mcValue.value2.selectable = true;
						break;
				}
				_ui.labelName.mouseEnabled = false;
			}
			addChild(_ui);
			
			if (_nameAttribute == "start") {
				_ui.mcValue.value1.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				_ui.mcValue.value1.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				_ui.mcValue.value2.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				_ui.mcValue.value2.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			}else if (_nameAttribute == "width" || _nameAttribute == "height") {
				_ui.mcValue.label.addEventListener(Event.CHANGE, changeSizeHandler);
				changeSizeHandler();
			}
		}
		
		// handlers
		private function mcValueBoolClickHandler(e:MouseEvent):void {
			_value = !_value;
			_ui.mcValue.mcCheck.visible = _value;
		}
		
		private function mcChoiceUrlClickHandler(e:MouseEvent):void {
			if (_file == null) {
				_file = new FileReference();
				_file.addEventListener(Event.SELECT, fileSelectedHandler);
			}
			_file.browse([new FileFilter("Images (*.jpg, *.jpeg, *.png)", "*.jpg;*.jpeg;*.png")]);
		}
		
		private function fileSelectedHandler(e:Event):void {
			_file.cancel();
			_ui.mcValue.label.text = _file.name;
		}
		
		private function focusInHandler(e:FocusEvent):void {
			_ui.mcValue.value1.addEventListener(Event.CHANGE, changeHandler);
			_ui.mcValue.value2.addEventListener(Event.CHANGE, changeHandler);
		}
		
		private function focusOutHandler(e:FocusEvent):void {
			_ui.mcValue.value1.removeEventListener(Event.CHANGE, changeHandler);
			_ui.mcValue.value2.removeEventListener(Event.CHANGE, changeHandler);
		}
		
		private function changeHandler(e:Event):void {
			dispatchEvent(new EditorEventChangeAttributeStart(EditorEventChangeAttributeStart.CHANGE_ATTRIBUTE_START, Number(EditorUtils.cutSideSpaces(_ui.mcValue.value1.text)), Number(EditorUtils.cutSideSpaces(_ui.mcValue.value2.text)), true));
		}
		
		private function changeSizeHandler(e:Event = null):void {
			_value = uint(_ui.mcValue.label.text);
			dispatchEvent(new Event(EditorItem.CHANGE_DEFAULT_SIZE));
		}
		
	}

}