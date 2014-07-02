package boxesandworlds.editor.data.items {
	import boxesandworlds.game.data.Attribute;
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAttributeData {
		
		// vars
		private var _attributeDataXML:XML;
		
		private var _attributeName:String;
		private var _type:String;
		private var _isEnum:Boolean;
		private var _isArray:Boolean;
		private var _valuesEnum:Array;
		
		/* if(_isArray == true) */
		private var _valuesArray:Vector.<String>;
		/* if(_isArray == false && _attributeName == start) */
		private var _value:String;
		/* if(_isArray == false && _attributeName != start) */
		private var _valueX:String;
		private var _valueY:String;
		
		public function EditorAttributeData(attributeDataXML:XML) {
			_attributeDataXML = attributeDataXML;
			setup();
		}
		
		// get
		public function get attributeName():String { return _attributeName; }
		
		public function get type():String { return _type; }
		
		public function get isEnum():Boolean { return _isEnum; }
		
		public function get isArray():Boolean { return _isArray; }
		
		public function get valuesEnum():Array { return _valuesEnum; }
		
		public function get valuesArray():Vector.<String> { return _valuesArray; }
		
		public function get value():String { return _value; }
		
		public function get valueX():String { return _valueX; }
		
		public function get valueY():String { return _valueY; }
		
		// protected
		protected function setup():void {
			_attributeName = _attributeDataXML.@attributeName;
			_type = _attributeDataXML.@type;
			_isArray = _attributeDataXML.@isArray == "true";
			_isEnum = _attributeDataXML.@isEnum == "true";
			if (_isArray) {
				_valuesArray = new Vector.<String>();
				for each(var child:XML in _attributeDataXML.*) {
					_valuesArray.push(child);
				}
			}else {
				if (_type == Attribute.VEC2) {
					_valueX = _attributeDataXML.@x;
					_valueY = _attributeDataXML.@y;
				}else {
					if (_isEnum) {
						_valuesEnum = [];
						for each(var childEnum:XML in _attributeDataXML.*) {
							_valuesEnum.push(childEnum);
						}
					}
					_value = _attributeDataXML.@value;
				}
			}
		}
		
	}
}