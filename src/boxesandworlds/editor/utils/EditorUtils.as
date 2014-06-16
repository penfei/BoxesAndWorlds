package boxesandworlds.editor.utils {
	import boxesandworlds.editor.data.items.EditorAttributeData;
	import boxesandworlds.editor.data.items.EditorItemData;
	import boxesandworlds.game.data.Attribute;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorUtils {
		
		// const
		static public const WORLD_WITDH:uint = 800;
		static public const WORLD_HEIGHT:uint = 800;
		static public const XML_NAME:String = "BaW.xml";
		
		static public function getItemName(name:String):String {
			var realName:String = "";
			var isPrevUpper:Boolean = false;
			for (var i:uint = 0, len:uint = name.length; i < len; ++i) {
				var c:String = name.charAt(i);
				if (c == c.toUpperCase() && i != 0 && !isPrevUpper) {
					realName += " ";
					realName += c;
					isPrevUpper = true;
				}else {
					realName += c;
					isPrevUpper = false;
				}
			}
			return realName;
		}
		
		static public function cutSideSpaces(str:String):String {
			var index:int = -1;
			for (var i:int = 0, len:uint = str.length; i < len; ++i) {
				if (str.charAt(i) != " " && str.charAt(i) != "\t" && str.charAt(i) != "\r" && str.charAt(i) != "\n") {
					index = i;
					break;
				}
			}
			str = str.substr(index);
			for (var j:int = str.length - 1; j >= 0; --j) {
				if (str.charAt(j) != " " && str.charAt(j) != "\t" && str.charAt(j) != "\r" && str.charAt(j) != "\n") {
					index = j;
					break;
				}
			}
			str = str.substring(0, index + 1);
			return str;
		}
		
		static public function createAttributesFromXML(itemData:EditorItemData):Vector.<Attribute> {
			var attributesData:Vector.<EditorAttributeData> = itemData.attributesData;
			var len:uint = attributesData.length;
			var attributes:Vector.<Attribute> = new Vector.<Attribute>();
			attributes.length = len;
			for (var i:uint = 0; i < len; ++i) {
				var attributeName:String = attributesData[i].attributeName;
				var type:String = attributesData[i].type;
				var isEnum:Boolean = attributesData[i].isEnum;
				var isArray:Boolean = attributesData[i].isArray;
				var value:*;
				if (type == Attribute.VEC2 && !isArray) {
					value = new Vec2(Number(attributesData[i].valueX), Number(attributesData[i].valueY));
				}else {
					if (isArray) {
						value = attributesData[i].valuesArray;
					}else {
						value = attributesData[i].value;
					}
				}
				var valuesEnum:Array;
				if (isEnum) {
					valuesEnum = attributesData[i].valuesEnum;
				}
				
				var attribute:Attribute = new Attribute(attributeName, value, type, true, isEnum, valuesEnum, isArray);
				attributes[i] = attribute;
			}
			return attributes;
		}
		
	}

}