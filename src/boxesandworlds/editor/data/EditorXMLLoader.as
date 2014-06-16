package boxesandworlds.editor.data {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author xiiii
	 */
	public class EditorXMLLoader extends EventDispatcher {
		
		// const
		static public const XML_DATA_LOADED:String = "editorXMLDataLoaded";
		
		// vars
		private var _file:FileReference;
		private var _levelData:EditorLevelData;
		
		public function EditorXMLLoader() {
			
		}
		
		// get
		public function get levelData():EditorLevelData { return _levelData; }
		
		// public
		public function openWindow():void {
			if (_file == null) {
				_file = new FileReference();
				_file.addEventListener(Event.SELECT, fileSelectedHandler);
			}
			_file.browse([new FileFilter("XML (*.xml)", "*.xml")]);
		}
		
		// handlers
		private function fileSelectedHandler(e:Event):void {
			_file.addEventListener(Event.COMPLETE, loadingXMLCompleteHandler);
			_file.load();
		}
		
		private function loadingXMLCompleteHandler(e:Event):void {
			_file.removeEventListener(Event.COMPLETE, loadingXMLCompleteHandler);
			var byteArray:ByteArray = ByteArray(_file.data);
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.bytesAvailable));
			_levelData = new EditorLevelData(xml);
			dispatchEvent(new Event(XML_DATA_LOADED));
		}
		
	}

}