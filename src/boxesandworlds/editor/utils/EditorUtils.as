package boxesandworlds.editor.utils {
	import boxesandworlds.data.ObjectsLibrary;
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
		
		static public function getItemNameFromClass(className:String):String {
			var array:Array = className.split(" ");
			var result:String = array[1];
			return result.substring(0, result.length - 5);
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
			var indexClass:uint;
			for (var j:uint = 0, lenj:uint = ObjectsLibrary.objectDatas.length; j < lenj; ++j) {
				if (itemData.itemName == getItemNameFromClass(String(ObjectsLibrary.objectDatas[j]))) {
					indexClass = j;
				}
			}
			var attributesOriginal:Vector.<Attribute> = ObjectsLibrary.objectDatas[indexClass].attributes();
			
			var attributesData:Vector.<EditorAttributeData> = itemData.attributesData;
			var attributes:Vector.<Attribute> = new Vector.<Attribute>();
			for (var i:uint = 0; i < attributesOriginal.length; ++i) {
				if (!attributesOriginal[i].redactorAction) {
					continue;
				}
				var originalName:String = attributesOriginal[i].name;
				var isExist:Boolean = false;
				var indexExist:int;
				for (var g:int = 0, leng:uint = attributesData.length; g < leng; ++g) {
					if (attributesData[g].attributeName == originalName) {
						isExist = true;
						indexExist = g;
						break;
					}
				}
				
				if (isExist) {
					var attributeName:String = attributesData[indexExist].attributeName;
					var type:String = attributesData[indexExist].type;
					var isEnum:Boolean = attributesData[indexExist].isEnum;
					var isArray:Boolean = attributesData[indexExist].isArray;
					var value:*;
					if (type == Attribute.VEC2 && !isArray) {
						value = new Vec2(Number(attributesData[indexExist].valueX), Number(attributesData[indexExist].valueY));
					}else {
						if (isArray) {
							value = attributesData[indexExist].valuesArray;
						}else {
							value = attributesData[indexExist].value;
						}
					}
					var valuesEnum:Array;
					if (isEnum) {
						valuesEnum = attributesData[indexExist].valuesEnum;
					}
					
					var attribute:Attribute = new Attribute(attributeName, value, type, 1, isEnum, valuesEnum, isArray);
					attributes.push(attribute);
				}else {
					attributes.push(attributesOriginal[i]);
				}
			}
			return attributes;
		}
		
	}

}