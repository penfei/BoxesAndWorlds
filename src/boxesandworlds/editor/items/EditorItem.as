package boxesandworlds.editor.items {
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
		private var _id:String;
		private var _isShowedWarning:Boolean;
		private var _isSelectable:Boolean;
		private var _attributes:Vector.<Attribute>;
		
		public function EditorItem(id:String, attributes:Vector.<Attribute>) {
			_id = id;
			_attributes = attributes;
			setup();
		}
		
		// get
		public function get id():String { return _id; }
		
		public function get isShowedWarning():Boolean { return _isShowedWarning; }
		
		public function get mcAttributes():Vector.<EditorAttribute> { return _mcAttributes; }
		
		public function get isSelectable():Boolean { return _isSelectable; }
		
		// public
		public function destroy():void {
			
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
		
		// protected
		protected function setup():void {
			//_ui = new EditorItemsEnum.EDITOR_ITEMS_UI_CLASS[_id]();
			_ui = new EditorItemUI;
			_ui.label.text = String(_id);
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
			_mcAttributes.length = len;
			var type:String = "";
			for (var i:uint = 0; i < len; ++i) {
				if (!_attributes[i].isEnum) {
					type = _attributes[i].type;
				}
				var attribute:EditorAttribute = new EditorAttribute(_attributes[i].isEnum, type, _attributes[i].value);
				_mcAttributes[i] = attribute;
			}
		}
		
	}
}