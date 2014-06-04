package boxesandworlds.editor.items {
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import com.greensock.TweenMax;
	import editor.EditorItemUI;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItem extends Sprite {
		
		// ui
		//private var _ui:MovieClip;
		private var _ui:EditorItemUI;
		private var _mcWarning:Sprite;
		private var _mcAttributes:Vector.<EditorAttribute>;
		
		// vars
		private var _nameItem:String;
		private var _id:String;
		private var _uniqueId:int;
		private var _attributes:Vector.<Attribute>;
		private var _isShowedWarning:Boolean;
		private var _isSelectable:Boolean;
		
		public function EditorItem(id:String, uniqueId:int, attributes:Vector.<Attribute>) {
			_id = id;
			_uniqueId = uniqueId;
			_attributes = attributes;
			setup();
		}
		
		// get
		public function get nameItem():String { return _nameItem; }
		
		public function get id():String { return _id; }
		
		public function get uniqueId():int { return _uniqueId; }
		
		public function get mcAttributes():Vector.<EditorAttribute> { return _mcAttributes; }
		
		public function get isShowedWarning():Boolean { return _isShowedWarning; }
		
		public function get isSelectable():Boolean { return _isSelectable; }
		
		// public
		public function destroy():void {
			if (_mcAttributes != null) {
				var mcAttribute:EditorAttribute;
				for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
					mcAttribute = _mcAttributes[i];
					if (mcAttribute != null) {
						mcAttribute.destroy();
						if (mcAttribute.parent != null) {
							mcAttribute.parent.removeChild(mcAttribute);
						}
						mcAttribute = null;
					}
				}
				_mcAttributes = null;
			}
			if (_ui != null) {
				if (_ui.parent != null) {
					_ui.parent.removeChild(_ui);
				}
				_ui = null;
			}
		}
		
		public function showWarning():void {
			_isShowedWarning = true;
			TweenMax.to(_mcWarning, .3, { alpha:1 } );
		}
		
		public function hideWarning():void {
			_isShowedWarning = false;
			TweenMax.to(_mcWarning, .3, { alpha:0 } );
		}
		
		public function setupSelectable(value:Boolean):void {
			_isSelectable = value;
			var alpha:Number = _isSelectable ? 1 : 0;
			TweenMax.to(_ui.mcSelect, .3, { alpha:alpha } );
		}
		
		public function setupAttribute(name:String, value:*):void {
			for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
				if (_mcAttributes[i].nameAttribute == name) {
					_mcAttributes[i].setupValue(value);
					break;
				}
			}
		}
		
		// protected
		protected function setup():void {
			//_ui = new EditorItemsEnum.EDITOR_ITEMS_UI_CLASS[_id]();
			var nameEditor:String = "";
			for (var j:uint = 0, lenj:uint = _attributes.length; j < lenj; ++j) {
				if (_attributes[j].name == "type") {
					_nameItem = String(_attributes[j].value);
					nameEditor = EditorUtils.getItemName(String(_attributes[j].value));
				}
				if (_attributes[j].name == "id") {
					_attributes[j].value = _uniqueId;
				}
			}
			
			_ui = new EditorItemUI;
			_ui.label.text = nameEditor;
			_ui.label.mouseEnabled = false;
			addChild(_ui);
			
			_mcWarning = new Sprite();
			_mcWarning.graphics.beginFill(0xff0000, .5);
			_mcWarning.graphics.drawRect(0, 0, _ui.width, _ui.height);
			_mcWarning.graphics.endFill();
			_mcWarning.mouseChildren = _mcWarning.mouseEnabled = false;
			_mcWarning.alpha = 0;
			addChild(_mcWarning);
			
			var len:uint = _attributes.length;
			_mcAttributes = new Vector.<EditorAttribute>();
			var type:String = "";
			for (var i:int = 0; i < len; ++i) {
				if (_attributes[i].showInRedactor) {
					type = _attributes[i].type;
					var attribute:EditorAttribute = new EditorAttribute(i, _attributes[i].name, _attributes[i].isEnum, type, _attributes[i].value, _attributes[i].defaultValue, _attributes[i].enumValues);
					_mcAttributes.push(attribute);
				}
			}
		}
		
	}
}