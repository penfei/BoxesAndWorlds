package boxesandworlds.editor.utils {
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorUtils {
		
		static public const WORLD_WITDH:uint = 800;
		static public const WORLD_HEIGHT:uint = 800;
		
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
		
	}

}