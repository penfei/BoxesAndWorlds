package boxesandworlds.editor.data {
	import boxesandworlds.editor.data.items.EditorLevelScriptData;
	import boxesandworlds.editor.data.items.EditorPlayerData;
	import boxesandworlds.editor.data.items.EditorWorldData;
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorLevelData {
		
		// vars
		private var _xml:XML;
		
		private var _levelScriptData:EditorLevelScriptData;
		private var _playerData:EditorPlayerData;
		private var _worldsData:Vector.<EditorWorldData>;
		
		public function EditorLevelData(xml:XML) {
			_xml = xml;
			setup();
		}
		
		// get
		public function get levelScriptData():EditorLevelScriptData { return _levelScriptData; }
		
		public function get playerData():EditorPlayerData { return _playerData; }
		
		public function get worldsData():Vector.<EditorWorldData> { return _worldsData; }
		
		// protected
		protected function setup():void {
			_levelScriptData = new EditorLevelScriptData(_xml.levelScript.@scriptName);
			_playerData = new EditorPlayerData(_xml.player.@worldId, _xml.player.@x, _xml.player.@y);
			
			_worldsData = new Vector.<EditorWorldData>();
			var counterWorld:uint = 0;
			for each(var child:XML in _xml.*) {
				if (counterWorld >= 2) {
					_worldsData.push(new EditorWorldData(child));
				}
				counterWorld++;
			}
		}
		
	}
}