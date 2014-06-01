package boxesandworlds.editor.utils {
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorUtils {
		
		// const
		static public const WORLD_WITDH:uint = 800;
		static public const WORLD_HEIGHT:uint = 800;
		static public const XML_NAME:String = "BaW.xml";
		
		static public function getItemId(item:String):String {
			var wasSpace:Boolean = false;
			var id:String = "";
			for (var i:uint, len:uint = item.length; i < len - 1; ++i) {
				if (wasSpace) {
					id += item.charAt(i);
				}
				if (item.charAt(i) == ' ') {
					wasSpace = true;
				}
			}
			return id;
		}
		
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
		
	}

}