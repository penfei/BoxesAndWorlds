package boxesandworlds.editor.data.items {
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorPlayerData {
		
		// vars
		private var _playerWorldId:String;
		private var _playerPositionX:String;
		private var _playerPositionY:String;
		
		public function EditorPlayerData(playerWorldId:String, playerPositionX:String, playerPositionY:String) {
			_playerWorldId = playerWorldId;
			_playerPositionX = playerPositionX;
			_playerPositionY = playerPositionY;
		}
		
		// get
		public function get playerWorldId():String { return _playerWorldId; }
		
		public function get playerPositionX():String { return _playerPositionX; }
		
		public function get playerPositionY():String { return _playerPositionY; }
		
	}
}