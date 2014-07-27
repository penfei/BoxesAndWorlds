package boxesandworlds.editor.items.items_array {
	import boxesandworlds.editor.events.EditorEventChangeViewItem;
	import boxesandworlds.editor.UploadFile;
	import boxesandworlds.editor.utils.EditorUtils;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import editor.EditorAttributeArrayUrlUI;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author xiiii
	 */
	public class EditorItemArrayUrl extends EditorItemArray {
		
		// const
		static public const DEFAULT_VALUE:String = "url";
		private const DURATION_SECONDS_BEFORE_CHANGE:Number = 2;
		
		// ui
		private var _ui:EditorAttributeArrayUrlUI;
		
		// vars
		private var _file:FileReference;
		private var _fileData:UploadFile;
		private var _defaultValue:String;
		private var _index:int;
		
		public function EditorItemArrayUrl(defaultValue:String = DEFAULT_VALUE, index:int = -1) {
			_defaultValue = defaultValue;
			_index = index;
			setup();
		}
		
		// get
		override public function get valueXML():String {
			return EditorUtils.cutSideSpaces(_ui.labelName.text);
		}
		
		override public function get value():String { 
			return EditorUtils.cutSideSpaces(_ui.labelName.text);
		}
		
		// set
		override public function set value(value:String):void { 
			_ui.labelName.text = value; 
		}
		
		public function set index(value:int):void { _index = value; }
		
		// public
		public function changeUrl():void {
			dispatchEvent(new EditorEventChangeViewItem(EditorEventChangeViewItem.CHANGE_VIEW, _ui.labelName.text, _index, null, true));
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeArrayUrlUI;
			addChild(_ui);
			
			_ui.labelName.text = _defaultValue;
			_ui.labelName.selectable = true;
			_ui.labelName.type = TextFieldType.INPUT;
			_ui.labelName.addEventListener(Event.CHANGE, urlChangeHandler);
			_ui.mcChoiceUrl.buttonMode = true;
			_ui.mcChoiceUrl.addEventListener(MouseEvent.CLICK, mcChoiceUrlClickHandler);
		}
		
		// handlers
		private function urlChangeHandler(e:Event):void {
			TweenMax.killTweensOf(_ui.mcProgress.mc);
			_ui.mcProgress.mc.x = - _ui.mcProgress.mc.width;
			TweenMax.to(_ui.mcProgress.mc, DURATION_SECONDS_BEFORE_CHANGE, { x:0, ease:Linear.easeNone, onComplete: function scriptChanged():void {
				changeUrl();
			}});
		}
		
		private function mcChoiceUrlClickHandler(e:MouseEvent):void {
			if (_file == null) {
				_file = new FileReference();
				_file.addEventListener(Event.SELECT, fileSelectedHandler);
			}
			_file.browse([new FileFilter("Images (*.jpg, *.jpeg, *.png)", "*.jpg;*.jpeg;*.png")]);
		}
		
		private function fileSelectedHandler(e:Event):void {
			//_file.cancel();
			_ui.labelName.text = _file.name;
			_fileData = new UploadFile(_file);
			_fileData.addEventListener(Event.COMPLETE, contentLoadedHandler);
			_fileData.download();
		}
		
		private function contentLoadedHandler(e:Event):void {
			_fileData.removeEventListener(Event.COMPLETE, contentLoadedHandler);
			dispatchEvent(new EditorEventChangeViewItem(EditorEventChangeViewItem.CHANGE_VIEW, _ui.labelName.text, _index, _fileData.image, true));
		}
		
	}

}