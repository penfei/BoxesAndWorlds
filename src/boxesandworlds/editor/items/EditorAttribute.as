package boxesandworlds.editor.items {
	import boxesandworlds.game.data.Attribute;
	import editor.EditorAttributeBoolUI;
	import editor.EditorAttributeEnumUI;
	import editor.EditorAttributeNumberUI;
	import editor.EditorAttributeStringUI;
	import editor.EditorAttributeUrlUI;
	import editor.EditorAttributeVec2UI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAttribute extends Sprite {
		
		// ui
		private var _ui:MovieClip;
		
		// vars
		private var _name:String;
		private var _isEnum:Boolean;
		private var _type:String;
		private var _value:*;
		private var _enumValues:Array;
		
		private var _id:int;
		private var _file:FileReference;
		
		public function EditorAttribute(id:int, name:String, isEnum:Boolean, type:String = "", value:* = null, enumValues:Array = null) {
			_id = id;
			_name = name;
			_isEnum = isEnum;
			_type = type;
			_value = value;
			_enumValues = enumValues;
			setup();
		}
		
		// get
		public function get id():int { return _id; }
		
		// public
		public function destroy():void {
			if (_ui != null) {
				if (_ui.parent != null) {
					_ui.parent.removeChild(_ui);
				}
				_ui = null;
			}
		}
		
		// protected
		protected function setup():void {
			if (_isEnum) {
				_ui = new EditorAttributeEnum(_type, _enumValues, _id);
			}else {
				switch(_type) {
					case Attribute.BOOL:
						_ui = new EditorAttributeBoolUI;
						_ui.labelName.text = _name;
						_ui.mcValue.buttonMode = true;
						_ui.mcValue.addEventListener(MouseEvent.CLICK, mcValueBoolClickHandler);
						_ui.mcValue.mcCheck.visible = _value;
						break;
						
					case Attribute.NUMBER:
						_ui = new EditorAttributeNumberUI;
						_ui.labelName.text = _name;
						_ui.mcValue.label.type = TextFieldType.INPUT;
						_ui.mcValue.label.selectable = true;
						_ui.mcValue.label.text = String(_value);
						break;
						
					case Attribute.STRING:
						_ui = new EditorAttributeStringUI;
						_ui.labelName.text = _name;
						_ui.mcValue.label.type = TextFieldType.INPUT;
						_ui.mcValue.label.selectable = true;
						_ui.mcValue.label.text = String(_value);
						break;
						
					case Attribute.URL:
						_ui = new EditorAttributeUrlUI;
						_ui.labelName.text = _name;
						_ui.mcValue.label.type = TextFieldType.INPUT;
						_ui.mcValue.label.selectable = true;
						_ui.mcChoiceUrl.buttonMode = true;
						_ui.mcChoiceUrl.addEventListener(MouseEvent.CLICK, mcChoiceUrlClickHandler);
						_ui.mcValue.label.text = String(_value);
						break;
						
					case Attribute.VEC2:
						_ui = new EditorAttributeVec2UI;
						_ui.labelName.text = _name;
						var keys:Array = [];
						var values:Array = [];
						for each(var key:String in _value) {
							keys.push(key);
							values.push(_value[key]);
						}
						_ui.mcValue.key1.text = String(keys[0]) + ":";
						_ui.mcValue.value1.text = String(values[0]);
						_ui.mcValue.key2.text = String(keys[1]) + ":";
						_ui.mcValue.value2.text = String(values[1]);
						_ui.mcValue.value1.type = TextFieldType.INPUT;
						_ui.mcValue.value1.selectable = true;
						_ui.mcValue.value2.type = TextFieldType.INPUT;
						_ui.mcValue.value2.selectable = true;
						break;
				}
				_ui.labelName.mouseEnabled = false;
			}
			addChild(_ui);
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
		
	}

}