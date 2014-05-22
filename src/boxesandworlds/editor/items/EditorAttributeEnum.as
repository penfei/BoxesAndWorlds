package boxesandworlds.editor.items {
	import boxesandworlds.editor.events.EditorEventAttributes;
	import boxesandworlds.editor.events.EditorEventSetUpAttribute;
	import boxesandworlds.game.data.Attribute;
	import com.greensock.TweenMax;
	import editor.EditorAttributeBoolUI;
	import editor.EditorAttributeEnumUI;
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
		private var _enumValues:Array;
		private var _id:int;
		private var _isOpened:Boolean = false;
		
		public function EditorAttributeEnum(type:String, enumValues:Array, id:int) {
			_type = type;
			_enumValues = enumValues;
			_id = id;
			setup();
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAttributeEnumUI;
			addChild(_ui);
			
			var len:uint = _enumValues.length;
			_items = new Vector.<MovieClip>();
			_items.length = len;
			var index:int = -1;
			switch(_type) {
				case Attribute.BOOL:
					index = 0;
					break;
					
				case Attribute.NUMBER:
					index = 1;
					break;
					
				case Attribute.STRING:
					index = 2;
					break;
					
				case Attribute.URL:
					index = 3;
					break;
					
				case Attribute.VEC2:
					index = 4;
					break;
			}
			for (var i:uint = 0; i < len; ++i) {
				var item:MovieClip = new CLIPS[i]();
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
			
			_ui.mcMask.height = 25 * len;
			_ui.mcContent.y = -(25 * len);
		}
		
		protected function showHideEnum():void {
			var posY:Number = _isOpened ? 25 : -(25 * _items.length);
			TweenMax.to(_ui.mcContent, .4, { y: posY } );
			dispatchEvent(new EditorEventSetUpAttribute(EditorEventSetUpAttribute.SET_UP_ATTRIBUTE_ENUM, _id, true));
		}
		
		// handlers
		private function itemClickHandler(e:MouseEvent):void {
			var item:MovieClip = e.currentTarget as MovieClip;
			if (item != null) {
				_currentItem.y = item.y;
				_ui.mcContent.addChild(_currentItem);
				_currentItem = item;
				item.y = 0;
				_ui.mcHeader.addChild(_currentItem);
				_isOpened = !_isOpened;
				showHideEnum();
			}
		}
		
	}

}