package boxesandworlds.editor.controls {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorVerticalScroller extends MovieClip {
		
		// const
		static public const CLICK_SCROLL:String = "clickScroll";
		
		// ui
		protected var _scroller:MovieClip;
		protected var _scroll:MovieClip;
		protected var _content:DisplayObjectContainer;
		protected var _rectangle:Rectangle;
		protected var _stage:Object;
		
		// vars
		private var _timeAnimation:Number = .4;
		private var _speedWheel:int = 45;
		private const _speedMax:int = 100;
		private var _speedCoef:uint = 30;
		
		private var _sideUp:Boolean;
		private var _eventsForClickScroll:Boolean;
		
		public function EditorVerticalScroller(scroller:MovieClip, content:DisplayObjectContainer, st:Object) {
			_scroller = scroller;
			_scroll = scroller;
			_content = content;
			_stage = st;
			stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {			
			_scroller.cont.addChild(_content);
			addChild(_scroll);
			
			createRectangle();
			
			_scroller.scroller.slider.buttonMode = true;
			_scroller.scroller.slider.addEventListener(MouseEvent.MOUSE_DOWN, dragHandler, false , 0, true);
			_scroller.scroller.bg.addEventListener(MouseEvent.MOUSE_DOWN, bgDownHandler, false , 0, true);
			_scroller.scroller.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler, false, 0, true);
			if(_scroller.cont.height - 5 > _scroller.mask_mc.height){}
				//_stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelRules);
			else
				_scroller.scroller.visible = false;
				
			if (_scroller.scroller.arrowUp != null && _scroller.scroller.arrowDown != null) {
				_scroller.scroller.arrowUp.addEventListener(MouseEvent.MOUSE_DOWN, arrowUpDownHandler, false, 0, true);
				_scroller.scroller.arrowUp.addEventListener(MouseEvent.MOUSE_UP, arrowStopHandler, false, 0, true);
				_scroller.scroller.arrowUp.addEventListener(MouseEvent.MOUSE_OUT, arrowStopHandler, false, 0, true);
				_scroller.scroller.arrowDown.addEventListener(MouseEvent.MOUSE_DOWN, arrowDownDownHandler, false, 0, true);
				_scroller.scroller.arrowDown.addEventListener(MouseEvent.MOUSE_UP, arrowStopHandler, false, 0, true);
				_scroller.scroller.arrowDown.addEventListener(MouseEvent.MOUSE_OUT, arrowStopHandler, false, 0, true);
				_scroller.scroller.arrowUp.buttonMode = true;
				_scroller.scroller.arrowDown.buttonMode = true;
			}
			
			_speedWheel = _content.height / _speedCoef;
			if (_speedWheel > _speedMax) {
				_speedWheel = _speedMax;
			}
				
			_scroller.over.mouseEnabled = _scroller.over.mouseChildren = false;
			_scroller.addEventListener(MouseEvent.MOUSE_OVER, activate);
			_scroller.addEventListener(MouseEvent.MOUSE_OUT, deactivate);
			
			_eventsForClickScroll = false;
		}
		
		//public
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (_stage != null) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveContentHandler);
				_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelRules);
			}
			if (_scroller != null) {
				_scroller.removeEventListener(MouseEvent.MOUSE_OVER, activate);
				_scroller.removeEventListener(MouseEvent.MOUSE_OUT, deactivate);
				_scroller.scroller.slider.removeEventListener(MouseEvent.MOUSE_DOWN, dragHandler);
				_scroller.scroller.bg.removeEventListener(MouseEvent.MOUSE_DOWN, bgDownHandler);
				_scroller.scroller.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			}
			if (_scroller.scroller.arrowUp != null && _scroller.scroller.arrowDown != null) {
				_scroller.scroller.arrowUp.removeEventListener(MouseEvent.MOUSE_DOWN, arrowUpDownHandler);
				_scroller.scroller.arrowUp.removeEventListener(MouseEvent.MOUSE_UP, arrowStopHandler);
				_scroller.scroller.arrowUp.removeEventListener(MouseEvent.MOUSE_OUT, arrowStopHandler);
				_scroller.scroller.arrowDown.removeEventListener(MouseEvent.MOUSE_DOWN, arrowDownDownHandler);
				_scroller.scroller.arrowDown.removeEventListener(MouseEvent.MOUSE_UP, arrowStopHandler);
				_scroller.scroller.arrowDown.removeEventListener(MouseEvent.MOUSE_OUT, arrowStopHandler);
			}
		}
		
		public function removeContent():DisplayObjectContainer {
			if (_content != null) {
				if (_scroller.cont.contains(_content))
					_scroller.cont.removeChild(_content);
			}
			return _content;
		}
		
		public function setupContentDown():void {
			if (_scroller.cont.height - 5 > _scroller.mask_mc.height) {
				TweenMax.to(_scroller.scroller.slider, .01, { y: _scroller.scroller.bg.y + _scroller.scroller.bg.height - _scroller.scroller.slider.height, ease:Expo.easeOut });
				TweenMax.to(_scroller.cont, .01, { y: _scroller.mask_mc.y - ((_scroller.cont.height - _scroller.mask_mc.height)), ease:Expo.easeOut });
			}
		}
		
		public function get content():Sprite { return _scroller.cont; }
		
		public function get scroll():MovieClip { return _scroll; }
		
		public function removeChildsFromContent():void {
			while (_scroller.cont.numChildren > 0) {
				_scroller.cont.removeChildAt(0);
			}
		}
		
		public function updateScroll():void {
			if (_scroller.cont.height - 5 > _scroller.mask_mc.height) {
				_scroller.scroller.visible = true;
			}else {
				_scroller.scroller.visible = false;
			}
			_content.y = 0;
			_scroller.cont.y = 0;
			_scroller.scroller.slider.y = 0;
			//createRectangle();
		}
		
		public function replaceContent(newContent:DisplayObjectContainer):void {
			if (_content != null) {
				if (_scroller.cont.contains(_content))
					_scroller.cont.removeChild(_content);
				_content = null;
			}
			_content = newContent;
			_scroller.cont.addChild(_content);
			_content.y = 0;
			_scroller.cont.y = 0;
			_scroller.scroller.slider.y = 0;
			createRectangle();
			if (_scroller.cont.height - 5 > _scroller.mask_mc.height) {
				_scroller.scroller.visible = true;
			}else {
				_scroller.scroller.visible = false;
			}
		}
		
		public function set sideUp(value:Boolean):void { _sideUp = value; }
		
		public function setupEventsForClickScroll(value:Boolean):void {
			_eventsForClickScroll = value;
		}
		
		// private 
		private function createRectangle():void {
			_rectangle = new Rectangle(_scroller.scroller.slider.x, _scroller.scroller.bg.y, 0, _scroller.scroller.bg.height - _scroller.scroller.slider.height);
		}
		
		// handlers
		public function wheelRules(e:MouseEvent = null):void {
			var c:Number = 0;
			if (e != null) {
				if (e.delta < 0) {
					c = -_speedWheel;
				}else {
					c = _speedWheel;
				}
			}else {
				if (_sideUp) {
					c = _speedWheel;
				}else {
					c = -_speedWheel;
				}
			}
			var toCont:Number;
			if (_scroller.cont.y + c > 0) {
				toCont = 0;
				TweenMax.to(_scroller.cont, _timeAnimation, { y: toCont, ease:Expo.easeOut });
			}else if (_scroller.cont.y + _scroller.cont.height + c <= _scroller.mask_mc.y + _scroller.mask_mc.height) {
				toCont = _scroller.mask_mc.y + _scroller.mask_mc.height - _scroller.cont.height;
				TweenMax.to(_scroller.cont, _timeAnimation, { y: toCont, ease:Expo.easeOut });
			}else {
				toCont = _scroller.cont.y + c;
				TweenMax.to(_scroller.cont, _timeAnimation, { y: toCont, ease:Expo.easeOut });
			}
			var dest:Number = -(toCont / (_scroller.cont.height - _scroller.mask_mc.height));
			var to:Number = (_rectangle.height * dest);
			if (to > _scroller.scroller.bg.y + _scroller.scroller.bg.height) {
				to = _scroller.scroller.bg.y + _scroller.scroller.bg.height;
			}else if (to < 0) {
				to = 0;
			}
			_scroller.scroller.slider.y = to;
		}
		
		private function dragHandler(e:MouseEvent = null):void {
			_scroller.scroller.slider.startDrag(false, _rectangle );
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, moveContentHandler, false, 0, true);
			moveContentHandler();
			if (_eventsForClickScroll) {
				dispatchEvent(new Event(CLICK_SCROLL));
			}
		}
		
		private function bgDownHandler(e:MouseEvent):void {
			_scroller.scroller.slider.y = _scroller.scroller.mouseY - _scroller.scroller.slider.height / 2;
			if (_scroller.scroller.slider.y + _scroller.scroller.slider.height > _scroller.scroller.bg.y + _scroller.scroller.bg.height) {
				_scroller.scroller.slider.y = _scroller.scroller.bg.y + _scroller.scroller.bg.height - _scroller.scroller.slider.height;
			}else if (_scroller.scroller.slider.y < 0) {
				_scroller.scroller.slider.y = 0;
			}
			dragHandler();
		}
		
		private function stopDragHandler(e:MouseEvent):void {
			_scroller.scroller.slider.stopDrag();
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveContentHandler);
		}
		
		private function moveContentHandler(e:MouseEvent = null):void {
			var dest:Number = (_scroller.scroller.slider.y / _rectangle.height);
			if (dest > 0.98)
				dest = 1;
			var to:Number = _scroller.mask_mc.y - ((_scroller.cont.height - _scroller.mask_mc.height) * dest);
			TweenMax.to(_scroller.cont, _timeAnimation, { y: to, ease:Expo.easeOut });
		}
		
		private function activate(e:MouseEvent):void {
			if (_scroller.cont.height - 5 > _scroller.mask_mc.height)
				_stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelRules);
		}
		
		private function deactivate(e:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelRules);
		}
		
		private function arrowUpDownHandler(e:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sideUp = true;
			//wheelRules(null);
		}
		
		private function arrowDownDownHandler(e:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sideUp = false;
			//wheelRules(null);
		}
		
		private function arrowStopHandler(e:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void {
			wheelRules(null);
		}
		
	}
}