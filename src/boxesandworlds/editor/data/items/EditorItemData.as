package boxesandworlds.editor.data.items {
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItemData {
		
		// vars
		private var _itemXMLData:XML;
		
		private var _itemName:String;
		private var _uniqueId:String
		private var _attributesData:Vector.<EditorAttributeData>;
		
		public function EditorItemData(itemXMLData:XML) {
			_itemXMLData = itemXMLData;
			setup();
		}
		
		// get
		public function get itemName():String { return _itemName; }
		
		public function get uniqueId():String { return _uniqueId; }
		
		public function get attributesData():Vector.<EditorAttributeData> { return _attributesData; }
		
		// protected
		protected function setup():void {
			_itemName = _itemXMLData.@itemName;
			_uniqueId = _itemXMLData.id.@value;
			
			_attributesData = new Vector.<EditorAttributeData>();
			for each(var child:XML in _itemXMLData.*) {
				_attributesData.push(new EditorAttributeData(child));
			}
		}
		
	}
}