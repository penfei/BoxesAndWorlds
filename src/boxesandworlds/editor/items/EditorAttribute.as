package boxesandworlds.editor.items {
	import boxesandworlds.editor.events.EditorEventChangeAttributeStart;
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
		
		// ui
		private var _ui:MovieClip;
		
		// vars
		private var _nameAttribute:String;
		private var _isEnum:Boolean;
		private var _type:String;
		private var _value:*;
		private var _enumValues:Array;
		
		private var _defaultValue:*;
		private var _id:int;
		private var _file:FileReference;
		
		public function EditorAttribute(id:int, name:String, isEnum:Boolean, type:String = "", value:* = null, defaultValue:* = null, enumValues:Array = null) {
			_id = id;
			_nameAttribute = name;
			_isEnum = isEnum;
			_type = type;
			_value = value;
			_defaultValue = defaultValue;
			_enumValues = enumValues;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		public function get nameAttribute():String { return _nameAttribute; }
		
		public function get isEnum():Boolean { return _isEnum; }
		
		public function get type():String { return _type; }
		
		public function get valueXML():String { 
			var value:String = "value='";
			if (_isEnum) {
				value += _ui.value;
			}else {
				switch(_type) {
					case Attribute.BOOL:
						value += String(_ui.mcValue.mcCheck.visible);
						break;
						
					case Attribute.NUMBER:
					case Attribute.STRING:
					case Attribute.URL:
						value += _ui.mcValue.label.text;
						break;
						
					case Attribute.VEC2:
						value = "x='" + _ui.mcValue.value1.text + "' y='" + _ui.mcValue.value2.text;
						break;
				}
			}
			value += "'";
			return value; 
		}
		
		public function get isChanged():Boolean { 
			var isChanged:Boolean;
			if (isEnum) {
				isChanged = String(_defaultValue) != EditorAttributeEnum(_ui).value;
			}else {
				switch(_type) {
					case Attribute.BOOL:
						isChanged = Boolean(_defaultValue) != _ui.mcValue.mcCheck.visible;
						break;
						
					case Attribute.NUMBER:
					case Attribute.STRING:
					case Attribute.URL:
						isChanged = String(_value) != _ui.mcValue.label.text;
						break;
						
					case Attribute.VEC2:
						isChanged = String(Vec2(_defaultValue).x) != _ui.mcValue.value1.text || String(Vec2(_defaultValue).y) != _ui.mcValue.value2.text;
						break;
				}
			}
			return isChanged;
		}
		
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
					_ui.mcValue.label.text = String(value);
					break;
					
				case Attribute.VEC2:
					var result:Vec2 = value as Vec2;
					if (result != null) {
						_ui.mcValue.value1.text = String(result.x);
						_ui.mcValue.value2.text = String(result.y);
					}
					break;
			}
		}
		
		// protected
		protected function setup():void {
			if (_isEnum) {
				_ui = new EditorAttributeEnum(_type, _enumValues, String(_defaultValue), _id);
			}else {
				switch(_type) {
					case Attribute.BOOL:
						_ui = new EditorAttributeBoolUI;
						_ui.labelName.text = _nameAttribute;
						_ui.mcValue.buttonMode = true;
						_ui.mcValue.addEventListener(MouseEvent.CLICK, mcValueBoolClickHandler);
						_ui.mcValue.mcCheck.visible = _value;
						break;
						
					case Attribute.NUMBER:
						_ui = new EditorAttributeNumberUI;
						_ui.labelName.text = _nameAttribute;
						_ui.mcValue.label.type = TextFieldType.INPUT;
						_ui.mcValue.label.selectable = true;
						_ui.mcValue.label.text = String(_value);
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
			dispatchEvent(new EditorEventChangeAttributeStart(EditorEventChangeAttributeStart.CHANGE_ATTRIBUTE_START, Number(_ui.mcValue.value1.text), Number(_ui.mcValue.value2.text), true));
		}
		
	}

}