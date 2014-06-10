package boxesandworlds.editor.items {
	import boxesandworlds.editor.events.EditorEventSetUpAttribute;
	import boxesandworlds.editor.utils.EditorUtils;
	import com.greensock.TweenMax;
	import editor.EditorAttributeBoolUI;
	import editor.EditorAttributeEnumUI;
	import editor.EditorAttributeEnumValueUI;
	import editor.EditorAttributeNumberUI;
	import editor.EditorAttributeStringUI;
	import editor.EditorAttributeUrlUI;
	import editor.EditorAttributeVec2UI;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAttributeEnum extends MovieClip {
		
		// ui
		static private const CLIPS:Array = [EditorAttributeBoolUI, EditorAttributeNumberUI, EditorAttributeStringUI, EditorAttributeUrlUI, EditorAttributeVec2UI];
		private var _items:Vector.<MovieClip>;
		private var _ui:EditorAttributeEnumUI;
		private var _currentItem:MovieClip;
		
		// vars
		private var _type:String;
		private var _nameAttribute:String;
		private var _enumValues:Array;
		private var _defaultValue:String;
		private var _id:int;
		private var _isOpened:Boolean = false;
		
		public function EditorAttributeEnum(type:String, nameAttribute:String, enumValues:Array, defaultValue:String, id:int) {
			_type = type;
			_nameAttribute = nameAttribute;
			_enumValues = enumValues;
			_defaultValue = defaultValue;
			_id = id;
			setup();
		}
		
		// get
		public function get value():String { return EditorUtils.cutSideSpaces(_currentItem.labelName.text); }
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeEnumUI;
			_ui.labelName.mouseEnabled = false;
			_ui.labelName.text = _nameAttribute;
			addChild(_ui);
			
			var len:uint = _enumValues.length;
			_items = new Vector.<MovieClip>();
			_items.length = len;
			var index:int = -1;
			for (var i:uint = 0; i < len; ++i) {
				var item:EditorAttributeEnumValueUI = new EditorAttributeEnumValueUI;
				item.labelName.text = String(_enumValues[i]);
				_items[i] = item;
				if (i == 0) {
					_ui.mcHeader.addChild(item);
				}else {
					item.y = 25 * (i - 1);
					_ui.mcContent.addChild(item);
				}
				item.addEventListener(MouseEvent.CLICK, itemClickHandler);
			}
			_currentItem = _items[0];
			updateColors();
			
			if (_items[0].labelName.text != _defaultValue) {
				var tmp:String = _items[0].labelName.text;
				_items[0].labelName.text = _defaultValue;
				for (var j:uint = 1, lenj:uint = _items.length; j < lenj; ++j) {
					if (_items[j].labelName.text == _defaultValue) {
						_items[j].labelName.text = tmp;
						break;
					}
				}
			}
			
			_ui.mcMask.height = 25 * len;
			_ui.mcContent.y = -(25 * len);
		}
		
		protected function showHideEnum():void {
			var posY:Number = _isOpened ? 25 : -(25 * _items.length);
			TweenMax.to(_ui.mcContent, .4, { y: posY } );
			updateColors();
			dispatchEvent(new EditorEventSetUpAttribute(EditorEventSetUpAttribute.SET_UP_ATTRIBUTE_ENUM, _id, true));
		}
		
		protected function updateColors():void {
			for (var i:uint = 0, len:uint = _items.length; i < len; ++i) {
				_items[i].mc.visible = _isOpened;
			}
		}
		
		protected function doClickItem(item:MovieClip):void {
			_currentItem.y = item.y;
			_ui.mcContent.addChild(_currentItem);
			_currentItem = item;
			item.y = 0;
			_ui.mcHeader.addChild(_currentItem);
			_isOpened = !_isOpened;
			showHideEnum();
		}
		
		// handlers
		private function itemClickHandler(e:MouseEvent):void {
			var item:MovieClip = e.currentTarget as MovieClip;
			if (item != null) {
				doClickItem(item);
			}
		}
		
	}

}