package boxesandworlds.gui.control {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Slider extends EventDispatcher {
		public static const VALUE_CHANGED:String = "valueChanged";

		private var _ui:MovieClip;
		private var _isDrag:Boolean = false;
		private var _isMouseDown:Boolean = false;
		private var _value:Number;

		public function Slider(ui:MovieClip) {
			_ui = ui;
			setupUI();
		}

		// properties:
		public function get isDrag():Boolean {
			return _isDrag;
		}

		public function get lineHeight():Number {
			return _ui.line.height - handleHeight;
		}

		public function set lineHeight(width:Number):void {
			_ui.line.height = width;
			_ui.handle.y = value * lineHeight;
		}

		public function get handleHeight():Number {
			return _ui.handle.height;
		}

		public function get value():Number {
			return _value;
		}

		public function set value(value:Number):void {
			if (value != _value) {
				_value = value;
				updateValue();
			}
		}

		// protected:
		protected function setupUI():void {
			_ui.mouseChildren = false;
			_ui.buttonMode = true;

			_ui.addEventListener(MouseEvent.MOUSE_DOWN, sliderDownHandler, false, 0, true);
			_ui.addEventListener(MouseEvent.MOUSE_UP, sliderUpHandler, false, 0, true);
			_ui.addEventListener(MouseEvent.MOUSE_MOVE, sliderMoveHandler, false, 0, true);
		}

		// private:
		private function dispatchSliderEvent(type:String):void {
			var event:Event = new Event(type);
			dispatchEvent(event);
		}

		private function updateValue():void {
			if (!isDrag) {
				_ui.handle.y = value * lineHeight;
			}
		}

		public function setValue(value:Number):void {
			if (value != _value) {
				_value = value;
				updateValue();
				dispatchEvent(new Event(VALUE_CHANGED));
			}
		}

		// handlers:		
		private function sliderDownHandler(event:MouseEvent):void {
			_isMouseDown = true;
		}

		private function sliderUpHandler(event:MouseEvent):void {
			if (_isMouseDown && !_isDrag) {
				setValue(Math.max(0, Math.min(1, (event.localX - (handleHeight / 2)) / lineHeight)));
				_isMouseDown = false;
			}
		}

		private function sliderMoveHandler(event:MouseEvent):void {
			if (_isMouseDown && !_isDrag) {
				_ui.handle.y = event.localY - (handleHeight / 2);
				_ui.handle.startDrag(false, new Rectangle(0, 0, 0, lineHeight));

				_ui.stage.addEventListener(MouseEvent.MOUSE_UP, handleUpHandler, false, 0, true);
				_ui.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler, false, 0, true);

				_isDrag = true;
			}
		}

		private function handleUpHandler(event:MouseEvent):void {
			_ui.stage.removeEventListener(MouseEvent.MOUSE_UP, handleUpHandler);
			_ui.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
			_ui.handle.stopDrag();
			_isMouseDown = false;
			_isDrag = false;
			dispatchSliderEvent(VALUE_CHANGED);
		}

		private function stageMoveHandler(event:MouseEvent):void {
			setValue(Math.max(0, Math.min(1, _ui.handle.y / (lineHeight - 1))));
		}
	}
}
