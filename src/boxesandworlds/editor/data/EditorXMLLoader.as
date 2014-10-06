package boxesandworlds.editor.data {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
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
		private var _urlLoader:URLLoader;
		
		public function EditorXMLLoader() {
			
		}
		
		// get
		public function get levelData():EditorLevelData { return _levelData; }
		
		public function get fileName():String { return _file.name; }
		
		// public
		public function openWindow():void {
			if (_file == null) {
				_file = new FileReference();
				_file.addEventListener(Event.SELECT, fileSelectedHandler);
			}
			_file.browse([new FileFilter("XML (*.xml)", "*.xml")]);
		}
		
		public function loadXML(nameXML:String):void {
			var request:URLRequest = new URLRequest("../assets/" + nameXML);
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, loadXMLFromLoaderCompleteHandler);
			_urlLoader.load(request);
		}
		
		// handlers
		private function fileSelectedHandler(e:Event):void {
			_file.addEventListener(Event.COMPLETE, loadXMLFromFileCompleteHandler);
			_file.load();
		}
		
		private function loadXMLFromFileCompleteHandler(e:Event):void {
			_file.removeEventListener(Event.COMPLETE, loadXMLFromFileCompleteHandler);
			var byteArray:ByteArray = ByteArray(_file.data);
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.bytesAvailable));
			_levelData = new EditorLevelData(xml);
			dispatchEvent(new Event(XML_DATA_LOADED));
		}
		
		private function loadXMLFromLoaderCompleteHandler(e:Event):void {
			_urlLoader.removeEventListener(Event.COMPLETE, loadXMLFromLoaderCompleteHandler);
			var xml:XML = new XML(_urlLoader.data);
			_levelData = new EditorLevelData(xml);
			dispatchEvent(new Event(XML_DATA_LOADED));
		}
		
	}
}