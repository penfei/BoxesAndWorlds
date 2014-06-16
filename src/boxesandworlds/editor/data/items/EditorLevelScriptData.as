package boxesandworlds.editor.data.items {
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorLevelScriptData {
		
		// vars
		private var _levelScriptName:String;
		
		public function EditorLevelScriptData(levelScriptName:String) {
			_levelScriptName = levelScriptName;
		}
		
		// get
		public function get levelScriptName():String { return _levelScriptName; }
		
	}

}