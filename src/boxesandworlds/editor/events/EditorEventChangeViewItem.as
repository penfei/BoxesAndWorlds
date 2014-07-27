package boxesandworlds.editor.events {
	import flash.display.Bitmap;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventChangeViewItem extends Event {
		
		// const
		static public const CHANGE_VIEW:String = "editorEventChangeViewItem";
		static public const ADD_FIELD_VIEW:String = "editorEventAddFieldViewItem";
		static public const REMOVE_FIELD_VIEW:String = "editorEventRemoveFieldViewItem";
		
		// vars
		private var _url:String;
		private var _index:int;
		private var _image:Bitmap;
		
		public function EditorEventChangeViewItem(type:String, url:String = "", index:int = -1, image:Bitmap = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			_url = url;
			_index = index;
			_image = image;
			super(type, bubbles, cancelable);
		}
		
		// get
		public function get url():String { return _url; }
		
		public function get index():int { return _index; }
		
		public function get image():Bitmap { return _image; }
		
	}
}