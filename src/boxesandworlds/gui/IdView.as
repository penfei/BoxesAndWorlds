package boxesandworlds.gui {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import boxesandworlds.controller.UIManager;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author Sah
	 */
	public class IdView extends View {
		static protected const DEFAULT_ANIMATION_TIME:int = 1;
		private var _id:int = UIManager.NONE_ID;
		private var _destination:uint;
		private var _callBack:Function;
		
		public function IdView(id:int):void {
			_id = id;
			super();
		}
		
		// properties:		
		public function get id():uint {
			return _id;
		}
		
		public function hideAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			
		}
		
		public function showAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
		}
		
		protected function goBack(ui:MovieClip, callBack:Function, destination:uint = 0):void {
			_callBack = callBack;
			_destination = destination;
			ui.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var ui:MovieClip = e.target as MovieClip;
			var frame:uint = ui.currentFrame - 1;
			if (frame != _destination && frame) ui.gotoAndStop(frame);
			else {
				ui.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_callBack.call();
			}
		}
		
	
	}

}