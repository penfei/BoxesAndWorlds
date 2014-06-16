package boxesandworlds.editor.data.items {
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorWorldData {
		
		// vars
		private var _worldXMLData:XML;
		
		private var _id:String;
		private var _itemsData:Vector.<EditorItemData>;
		
		public function EditorWorldData(worldXMLData:XML) {
			_worldXMLData = worldXMLData;
			setup();
		}
		
		// get
		public function get id():String { return _id; }
		
		public function get itemsData():Vector.<EditorItemData> { return _itemsData; }
		
		// protected
		protected function setup():void {
			_id = _worldXMLData.@id;
			
			_itemsData = new Vector.<EditorItemData>();
			for each(var child:XML in _worldXMLData.*) {
				_itemsData.push(new EditorItemData(child));
			}
		}
		
	}

}