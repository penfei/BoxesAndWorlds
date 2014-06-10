package boxesandworlds.game.data 
{
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class Attribute 
	{
		static public const BOOL:String = "BOOL";
		static public const NUMBER:String = "NUMBER";
		static public const STRING:String = "STRING";
		static public const URL:String = "URL";
		static public const VEC2:String = "VEC2";
		
		public var name:String;
		public var value:*;
		public var type:String;
		public var showInRedactor:Boolean;
		public var isEnum:Boolean;
		public var isArray:Boolean;
		public var enumValues:Array;
		
		private var _defaultValue:*;
		
		public function Attribute(name:String, value:*, type:String, showInRedactor:Boolean = true, isEnum:Boolean = false, enumValues:Array = null, isArray:Boolean = false) 
		{
			this.name = name;
			this.value = value;
			this.type = type;
			this.showInRedactor = showInRedactor;
			this.isEnum = isEnum;
			this.enumValues = enumValues;
			this.isArray = isArray;
			_defaultValue = copy();
		}
		
		public static function pushAttribute(arr:Vector.<Attribute>, name:String, value:*, type:String, redactor:Boolean = true, enum:Boolean = false, enumValues:Array = null, isArray:Boolean = false):void 
		{
			for (var i:uint = 0; i < arr.length; i++ ) {
				if (arr[i].name == name) {
					arr.splice(i, 1, new Attribute(name, value, type, redactor, enum, enumValues, isArray));
					return;
				}
			}
			arr.push(new Attribute(name, value, type, redactor, enum, enumValues, isArray));
		}
		
		public function copy():* {
			if (isArray) {
				var arr:Array = [];
				for each(var element:* in value) {
					if (type == VEC2) arr.push((element as Vec2).copy());
					else arr.push(element);
				}
				return arr;
			}
			if (type == VEC2) return (value as Vec2).copy();
			return value;
		}
		
		public function get isChanged():Boolean {
			if (isArray) {
				for (var i:uint = 0; i < value.length; i++) {
					if (_defaultValue[i] != value[i]) return true;
				}
				return false;
			}
			if (type == VEC2) return _defaultValue.x != value.x || _defaultValue.y != value.y;
			return _defaultValue != value;
		}
		
		public function get defaultValue():* { return _defaultValue; }
		
	}

}