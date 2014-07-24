package boxesandworlds.editor.items {
	import boxesandworlds.editor.data.items.EditorItemData;
	import boxesandworlds.editor.events.EditorEventChangeContainerItem;
	import boxesandworlds.editor.events.EditorEventChangeViewItem;
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
		private var _ui:EditorItemUI;
		private var _containers:Array;
		private var _mcWarning:Sprite;
		private var _mcAttributes:Vector.<EditorAttribute>;
		
		// vars
		private var _nameItem:String;
		private var _uniqueId:int;
		private var _isShowedWarning:Boolean;
		private var _isSelectable:Boolean;
		
		public function EditorItem(uniqueId:int, attributes:Vector.<Attribute>) {
			_uniqueId = uniqueId;
			setup(attributes);
		}
		
		// get
		public function get nameItem():String { return _nameItem; }
		
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
			if (_mcAttributes != null) {
				for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
					if (_mcAttributes[i].nameAttribute == name) {
						_mcAttributes[i].setupValue(value);
						break;
					}
				}
			}
		}
		
		public function setupDataFromXML(itemData:EditorItemData):void {
			
		}
		
		// protected
		protected function setup(attributes:Vector.<Attribute>):void {
			var nameEditor:String = "";
			for (var j:uint = 0, lenj:uint = attributes.length; j < lenj; ++j) {
				if (attributes[j].name == "type") {
					_nameItem = String(attributes[j].value);
					nameEditor = EditorUtils.getItemName(String(attributes[j].value));
				}
				if (attributes[j].name == "id") {
					attributes[j].value = _uniqueId;
				}
			}
			
			var len:uint = attributes.length;
			_mcAttributes = new Vector.<EditorAttribute>();
			var type:String = "";
			for (var i:int = 0; i < len; ++i) {
				if (attributes[i].redactorAction) {
					type = attributes[i].type;
					var attribute:EditorAttribute = new EditorAttribute(i, attributes[i].name, attributes[i].isEnum, attributes[i].isArray, type, attributes[i].value, attributes[i].defaultValue, attributes[i].enumValues);
					_mcAttributes.push(attribute);
				}
			}
			
			createUI(nameEditor);
			createMCWarning();
		}
		
		protected function createUI(name:String = ""):void {
			_ui = new EditorItemUI;
			_ui.label.text = name;
			_ui.label.mouseEnabled = false;
			addChild(_ui);
			
			_containers = [];
			for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
				trace(_mcAttributes[i].nameAttribute);
				if (_mcAttributes[i].nameAttribute == EditorAttribute.NAME_ATTRIBUTE_VIEWS) {
					_mcAttributes[i].addEventListener(EditorEventChangeViewItem.ADD_FIELD_VIEW, addFieldViewItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeViewItem.REMOVE_FIELD_VIEW, removeFieldViewItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeViewItem.CHANGE_VIEW, changeViewItemHandler);
				}else if (_mcAttributes[i].nameAttribute == EditorAttribute.NAME_ATTRIBUTE_CONTAINERS) {
					_mcAttributes[i].addEventListener(EditorEventChangeContainerItem.ADD_FIELD_CONTAINER, addFieldContainerItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeContainerItem.REMOVE_FIELD_CONTAINER, removeFieldContainerItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeContainerItem.CHANGE_CONTAINER, changeContainerItemHandler);
				}
			}
		}
		
		protected function createMCWarning():void {
			_mcWarning = new Sprite();
			_mcWarning.graphics.beginFill(0xff0000, .5);
			_mcWarning.graphics.drawRect(2, 2, _ui.width - 8, _ui.height - 8);
			_mcWarning.graphics.endFill();
			_mcWarning.mouseChildren = _mcWarning.mouseEnabled = false;
			_mcWarning.alpha = 0;
			addChild(_mcWarning);
		}
		
		protected function getAttributeByName(nameAttribute:String):EditorAttribute {
			for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
				if (_mcAttributes[i].nameAttribute == nameAttribute) {
					return _mcAttributes[i];
				}
			}
			return null;
		}
		
		// handlers
		private function addFieldViewItemHandler(e:EditorEventChangeViewItem):void {
			var attribute:EditorAttribute = getAttributeByName(EditorAttribute.NAME_ATTRIBUTE_CONTAINERS);
			attribute.addFieldArray();
		}
		
		private function removeFieldViewItemHandler(e:EditorEventChangeViewItem):void {
			var attribute:EditorAttribute = getAttributeByName(EditorAttribute.NAME_ATTRIBUTE_CONTAINERS);
			attribute.removeFieldArray(e.id);
		}
		
		private function changeViewItemHandler(e:EditorEventChangeViewItem):void {
			trace("change view");
		}
		
		private function addFieldContainerItemHandler(e:EditorEventChangeContainerItem):void {
			var attribute:EditorAttribute = getAttributeByName(EditorAttribute.NAME_ATTRIBUTE_VIEWS);
			attribute.addFieldArray();
		}
		
		private function removeFieldContainerItemHandler(e:EditorEventChangeContainerItem):void {
			var attribute:EditorAttribute = getAttributeByName(EditorAttribute.NAME_ATTRIBUTE_VIEWS);
			attribute.removeFieldArray(e.id);
		}
		
		private function changeContainerItemHandler(e:EditorEventChangeContainerItem):void {
			trace("change container");
		}
	}
}