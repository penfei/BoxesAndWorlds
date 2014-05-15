package boxesandworlds.game.data 
{
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
		public var enumValues:Array;
		
		public function Attribute(name:String, value:*, type:String, showInRedactor:Boolean = true, isEnum:Boolean = false, enumValues:Array = null) 
		{
			this.name = name;
			this.value = value;
			this.type = type;
			this.showInRedactor = showInRedactor;
			this.isEnum = isEnum;
			this.enumValues = enumValues;
		}
		
		public static function pushAttribute(arr:Vector.<Attribute>, name:String, value:*, type:String, redactor:Boolean = true, enum:Boolean = false, enumValues:Array = null):void 
		{
			for (var i:uint = 0; i < arr.length; i++ ) {
				if (arr[i].name == name) {
					arr.splice(i, 1, new Attribute(name, value, type, redactor, enum, enumValues));
					return;
				}
			}
			arr.push(new Attribute(name, value, type, redactor, enum, enumValues));
		}
	}

}