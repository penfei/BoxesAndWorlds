package boxesandworlds.editor.area {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.controls.EditorVerticalScroller;
	import boxesandworlds.editor.events.EditorEventSetUpAttribute;
	import boxesandworlds.editor.items.EditorAttribute;
	import boxesandworlds.editor.items.EditorAttributeArray;
	import boxesandworlds.editor.items.EditorItem;
	import editor.EditorAreaAttributesUI;
	import editor.EditorScrollAttributesUI;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaAttributes extends Sprite {
		
		// const
		static public const UNIQUE_ID_UNSELECT_ITEM:int = -1;// это если не показываются атрибуты (предмет не выбран)
		
		// ui
		private var _ui:EditorAreaAttributesUI;
		private var _scroll:EditorVerticalScroller;
		private var _attributes:Vector.<EditorAttribute>;
		
		// vars
		private var _uniqueId:int = UNIQUE_ID_UNSELECT_ITEM;
		
		public function EditorAreaAttributes() {
			setup();
		}
		
		// public
		public function showAttributes(item:EditorItem):void {
			_uniqueId = item.uniqueId;
			_attributes = item.mcAttributes;
			var content:Sprite = new Sprite();
			var h:Number = 5;
			for (var i:uint = 0, len:uint = _attributes.length; i < len; ++i) {
				_attributes[i].x = 5;
				_attributes[i].y = h;
				content.addChild(_attributes[i]);
				_attributes[i].addEventListener(EditorEventSetUpAttribute.SET_UP_ATTRIBUTE_ENUM, setUpAttributeHandler);
				_attributes[i].addEventListener(EditorAttributeArray.ATTRIBUTE_ARRAY_UPDATE, attributeArrayUpdateHandler);
				h += _attributes[i].height;
			}
			content = addDownRectangleForScroll(content);
			_scroll.replaceContent(content);
		}
		
		public function hideAttributes():void {
			_scroll.removeContent();
			_scroll.updateScroll();
			_uniqueId = UNIQUE_ID_UNSELECT_ITEM;
		}
		
		// protected
		protected function setup():void {
			_ui = new EditorAreaAttributesUI;
			addChild(_ui);
			
			_scroll = new EditorVerticalScroller(new EditorScrollAttributesUI, new Sprite(), Core.stage);
			addChild(_scroll);
		}
		
		protected function addDownRectangleForScroll(content:Sprite):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x000000, 0);
			s.graphics.drawRect(0, 0, 1, 12);
			s.graphics.endFill();
			s.y = content.height;
			content.addChildAt(s, 0);
			return content;
		}
		
		// handlers
		private function setUpAttributeHandler(e:EditorEventSetUpAttribute):void {
			for (var i:int = 0, len:int = _attributes.length; i < len; ++i) {
				if (_attributes[i].id == e.id) {
					_attributes[i].parent.setChildIndex(_attributes[i], _attributes[i].parent.numChildren - 1);
					return;
				}
			}
		}
		
		private function attributeArrayUpdateHandler(e:Event):void {
			var attribute:EditorAttribute = e.currentTarget as EditorAttribute;
			if (attribute != null) {
				var content:DisplayObjectContainer = _scroll.removeContent();
				var index:int = content.getChildIndex(attribute);
				var h:Number = 5;
				var newContent:Sprite = new Sprite();
				for (var i:int = 0; i < content.numChildren; ++i) {
					var item:EditorAttribute = content.getChildAt(i) as EditorAttribute;
					if (item != null) {
						item.x = 5;
						item.y = h;
						newContent.addChild(item);
						h += item.height;
						--i;
					}
				}
				newContent = addDownRectangleForScroll(newContent);
				_scroll.replaceContent(newContent);
			}
		}
		
	}

}