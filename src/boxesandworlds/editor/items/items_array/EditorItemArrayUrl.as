package boxesandworlds.editor.items.items_array {
	import boxesandworlds.editor.utils.EditorUtils;
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
		
		// ui
		private var _ui:EditorAttributeArrayUrlUI;
		
		// vars
		private var _file:FileReference;
		private var _defaultValue:String;
		
		public function EditorItemArrayUrl(defaultValue:String = DEFAULT_VALUE) {
			_defaultValue = defaultValue;
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
		
		// public
		public function changeUrl():void {
			
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeArrayUrlUI;
			addChild(_ui);
			
			_ui.labelName.text = _defaultValue;
			_ui.labelName.selectable = true;
			_ui.labelName.type = TextFieldType.INPUT;
			_ui.mcChoiceUrl.buttonMode = true;
			_ui.mcChoiceUrl.addEventListener(MouseEvent.CLICK, mcChoiceUrlClickHandler);
		}
		
		private function mcChoiceUrlClickHandler(e:MouseEvent):void {
			if (_file == null) {
				_file = new FileReference();
				_file.addEventListener(Event.SELECT, fileSelectedHandler);
			}
			_file.browse([new FileFilter("Images (*.jpg, *.jpeg, *.png)", "*.jpg;*.jpeg;*.png")]);
		}
		
		private function fileSelectedHandler(e:Event):void {
			_file.cancel();
			_ui.labelName.text = _file.name;
		}
		
	}

}