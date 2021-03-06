package boxesandworlds.editor.items {
	import boxesandworlds.editor.data.items.EditorItemData;
	import boxesandworlds.editor.events.EditorEventChangeContainerItem;
	import boxesandworlds.editor.events.EditorEventChangeViewItem;
	import boxesandworlds.editor.events.EditorEventUpdateContainerItem;
	import boxesandworlds.editor.events.EditorEventUpdateViewItem;
	import boxesandworlds.editor.items.items_array.EditorItemArrayNumber;
	import boxesandworlds.editor.items.items_array.EditorItemArrayUrl;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.game.data.Attribute;
	import com.greensock.TweenMax;
	import editor.EditorItemUI;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import nape.geom.Vec2;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorItem extends EventDispatcher {
		
		// const
		static public const CHANGE_DEFAULT_SIZE:String = "EditorChangeDefaultSize";
		
		private const DEFAULT_WIDTH:uint = 100;
		private const DEFAULT_HEIGHT:uint = 100;
		
		// ui
		private var _viewDefault:EditorItemViewDefault;
		private var _views:Vector.<EditorItemView>;
		private var _mcWarning:Sprite;
		private var _mcAttributes:Vector.<EditorAttribute>;
		
		// vars
		private var _nameItem:String;
		private var _uniqueId:int;
		private var _index:int;
		private var _isShowedWarning:Boolean;
		private var _isSelectable:Boolean;
		private var _indexOfAttributeViews:int = -1;
		private var _indexOfAttributeContainers:int;
		
		public function EditorItem(uniqueId:int, index:int, attributes:Vector.<Attribute>) {
			_uniqueId = uniqueId;
			_index = index;
			setup(attributes);
		}
		
		// get
		public function get width():Number {
			if (_views.length == 0) {
				return _viewDefault.width;
			}
			var maxWidth:Number = 0;
			var isExistRealWidth:Boolean = false;
			for (var i:uint = 0, len:uint = _views.length; i < len; ++i) {
				if (_views[i] != null) {
					if (_views[i].width > maxWidth) {
						maxWidth = _views[i].width;
					}
					if (_views[i].width > 0) {
						isExistRealWidth = true;
					}
				}
			}
			if (isExistRealWidth) {
				return maxWidth;
			}else {
				return DEFAULT_WIDTH;
			}
		}
		
		public function get height():Number {
			if (_views.length == 0) {
				return _viewDefault.height;
			}
			var maxHeight:Number = 0;
			var isExistRealHeight:Boolean = false;
			for (var i:uint = 0, len:uint = _views.length; i < len; ++i) {
				if (_views[i] != null) {
					if (_views[i].height > maxHeight) {
						maxHeight = _views[i].height;
					}
					if (_views[i].height > 0) {
						isExistRealHeight = true;
					}
				}
			}
			if (isExistRealHeight) {
				return maxHeight;
			}else {
				return DEFAULT_WIDTH;
			}
		}
		
		public function get nameItem():String { return _nameItem; }
		
		public function get uniqueId():int { return _uniqueId; }
		
		public function get mcAttributes():Vector.<EditorAttribute> { return _mcAttributes; }
		
		public function get isShowedWarning():Boolean { return _isShowedWarning; }
		
		public function get isSelectable():Boolean { return _isSelectable; }
		
		public function get views():Vector.<EditorItemView> { return _views; }
		
		public function get viewDefault():EditorItemViewDefault { return _viewDefault; }
		
		public function get startPosition():Vec2 {
			for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
				if (_mcAttributes[i].nameAttribute == "start") {
					return _mcAttributes[i].value;
				}
			}
			return null;
		}
		
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
						_mcAttributes[i] = null;
					}
				}
				_mcAttributes = null;
			}
			if (_viewDefault != null) {
				if (_viewDefault.parent != null) {
					_viewDefault.parent.removeChild(_viewDefault);
				}
				_viewDefault = null;
			}
			for (var j:uint = 0, lenj:uint = _views.length; j < lenj; ++j) {
				if (_views[j] != null) {
					_views[j].destroy();
					if (_views[j].parent != null) {
						_views[j].parent.removeChild(_views[j]);
					}
					_views[j] = null;
				}
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
			TweenMax.to(_viewDefault.mcSelect, .3, { alpha:alpha } );
		}
		
		public function setupPosition(valueX:Number, valueY:Number, isValueX:Boolean = true, isValueY:Boolean = true):void {
			if (isValueX) {
				_viewDefault.x = valueX;
			}
			if (isValueY) {
				_viewDefault.y = valueY;
			}
			for (var i:uint = 0, len:uint = _views.length; i < len; ++i) {
				if (_views[i] != null) {
					if (isValueX) {
						_views[i].x = valueX;
					}
					if (isValueY) {
						_views[i].y = valueY;
					}
				}
			}
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
		
		public function loadViews():void {
			for (var i:uint = 0, len:uint = _views.length; i < len; ++i) {
				var itemView:EditorItemView = new EditorItemView();
				itemView.addEventListener(EditorItemView.UPDATE_ITEM_SIZE, updateItemSizeHandler);
				_views[i] = itemView;
			}
			if (_indexOfAttributeViews != -1) {
				var attributeArray:EditorAttributeArray = _mcAttributes[_indexOfAttributeViews].ui as EditorAttributeArray;
				if (attributeArray != null) {
					for (var j:uint = 0, lenj:uint = attributeArray.values.length; j < lenj; ++j) {
						var item:EditorItemArrayUrl = attributeArray.values[j] as EditorItemArrayUrl;
						if (item != null) {
							item.changeUrl();
						}
					}
				}
			}
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
			for (var i:int = 0; i < len; ++i) {
				if (attributes[i].redactorAction) {
					var attribute:EditorAttribute = new EditorAttribute(i, attributes[i].name, attributes[i].isEnum, attributes[i].isArray, attributes[i].type, attributes[i].value, attributes[i].defaultValue, attributes[i].enumValues);
					if (attributes[i].name == "width" || attributes[i].name == "height") {
						attribute.addEventListener(CHANGE_DEFAULT_SIZE, changeDefaultSizeHandler);
					}
					_mcAttributes.push(attribute);
				}
			}
			
			createUI(nameEditor);
			createMCWarning();
			updateSize();
		}
		
		protected function createUI(name:String = ""):void {
			_viewDefault = new EditorItemViewDefault(this);
			_viewDefault.width = DEFAULT_WIDTH;
			_viewDefault.height = DEFAULT_HEIGHT;
			
			_views = new Vector.<EditorItemView>();
			for (var i:int = 0, len:uint = _mcAttributes.length; i < len; ++i) {
				if (_mcAttributes[i].nameAttribute == EditorAttribute.NAME_ATTRIBUTE_VIEWS) {
					_indexOfAttributeViews = i;
					_mcAttributes[i].addEventListener(EditorEventChangeViewItem.ADD_FIELD_VIEW, addFieldViewItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeViewItem.REMOVE_FIELD_VIEW, removeFieldViewItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeViewItem.CHANGE_VIEW, changeViewItemHandler);
					_views.length = _mcAttributes[i].sizeArray;
				}else if (_mcAttributes[i].nameAttribute == EditorAttribute.NAME_ATTRIBUTE_CONTAINERS) {
					_indexOfAttributeContainers = i;
					_mcAttributes[i].addEventListener(EditorEventChangeContainerItem.ADD_FIELD_CONTAINER, addFieldContainerItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeContainerItem.REMOVE_FIELD_CONTAINER, removeFieldContainerItemHandler);
					_mcAttributes[i].addEventListener(EditorEventChangeContainerItem.CHANGE_CONTAINER, changeContainerItemHandler);
					_mcAttributes[i].setupListenersForContainers();
				}
			}
		}
		
		protected function createMCWarning():void {
			_mcWarning = new Sprite();
			_mcWarning.graphics.beginFill(0xff0000, .5);
			_mcWarning.graphics.drawRect(0, 0, _viewDefault.width, _viewDefault.height);
			_mcWarning.graphics.endFill();
			_mcWarning.mouseChildren = _mcWarning.mouseEnabled = false;
			_mcWarning.alpha = 0;
			_viewDefault.addChild(_mcWarning);
		}
		
		protected function getAttributeByName(nameAttribute:String):EditorAttribute {
			for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
				if (_mcAttributes[i].nameAttribute == nameAttribute) {
					return _mcAttributes[i];
				}
			}
			return null;
		}
		
		protected function updateSize():void {
			//var w:Number = this.width;
			//var h:Number = this.height;
			//_viewDefault.width = w;
			//_viewDefault.height = h;
			for (var i:uint = 0, len:uint = _mcAttributes.length; i < len; ++i) {
				if (_mcAttributes[i].nameAttribute == "width") {
					_viewDefault.width = uint(_mcAttributes[i].value);
				}else if (_mcAttributes[i].nameAttribute == "height") {
					_viewDefault.height = uint(_mcAttributes[i].value);
				}
			}
		}
		
		protected function destroyView(view:EditorItemView):void {
			if (view != null) {
				view.destroy();
				if (view.parent != null) {
					view.parent.removeChild(view);
				}
				view = null;
			}
		}
		
		protected function recalculateIndexes():void {
			var attributeUrl:EditorAttributeArray = (_mcAttributes[_indexOfAttributeViews].ui as EditorAttributeArray);
			for (var i:int = 0, len:uint = attributeUrl.values.length; i < len; ++i) {
				(attributeUrl.values[i] as EditorItemArrayUrl).index = i;
			}
			var attributeContainer:EditorAttributeArray = (_mcAttributes[_indexOfAttributeContainers].ui as EditorAttributeArray);
			for (var j:int = 0, lenj:uint = attributeContainer.values.length; j < lenj; ++j) {
				(attributeContainer.values[j] as EditorItemArrayNumber).index = j;
			}
		}
		
		protected function doAddFieldViewItem():void {
			_mcAttributes[_indexOfAttributeContainers].addFieldArray();
			var itemView:EditorItemView = new EditorItemView();
			itemView.addEventListener(EditorItemView.UPDATE_ITEM_SIZE, updateItemSizeHandler);
			_views.push(itemView);
		}
		
		// handlers
		private function addFieldViewItemHandler(e:EditorEventChangeViewItem):void {
			doAddFieldViewItem();
		}
		
		private function removeFieldViewItemHandler(e:EditorEventChangeViewItem):void {
			_mcAttributes[_indexOfAttributeContainers].removeFieldArray(e.index);
			var view:EditorItemView = _views[e.index];
			_views.splice(e.index, 1);
			destroyView(view);
			updateSize();
			recalculateIndexes();
		}
		
		private function changeViewItemHandler(e:EditorEventChangeViewItem):void {
			var containerId:int = (_mcAttributes[_indexOfAttributeContainers].ui as EditorAttributeArray).getContainerIdByIndex(e.index);
			if (e.image == null) {
				_views[e.index].loadView(e.url, containerId);
			}else {
				_views[e.index].setupImage(e.image);
			}
			dispatchEvent(new EditorEventUpdateViewItem(EditorEventUpdateViewItem.UPDATE_VIEW, _index, e.index));
		}
		
		private function addFieldContainerItemHandler(e:EditorEventChangeContainerItem):void {
			var attribute:EditorAttribute = getAttributeByName(EditorAttribute.NAME_ATTRIBUTE_VIEWS);
			attribute.addFieldArray();
			var itemView:EditorItemView = new EditorItemView();
			itemView.addEventListener(EditorItemView.UPDATE_ITEM_SIZE, updateItemSizeHandler);
			_views.push(itemView);
		}
		
		private function removeFieldContainerItemHandler(e:EditorEventChangeContainerItem):void {
			_mcAttributes[_indexOfAttributeViews].removeFieldArray(e.index);
			var view:EditorItemView = _views[e.index];
			_views.splice(e.index, 1);
			destroyView(view);
			updateSize();
			recalculateIndexes();
		}
		
		private function changeContainerItemHandler(e:EditorEventChangeContainerItem):void {
			dispatchEvent(new EditorEventUpdateContainerItem(EditorEventUpdateContainerItem.UPDATE_CONTAINER, _index, e.index, e.value));
		}
		
		private function updateItemSizeHandler(e:Event):void {
			updateSize();
		}
		
		private function changeDefaultSizeHandler(e:Event):void {
			updateSize();
		}
	}
}