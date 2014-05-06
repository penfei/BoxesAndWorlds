package 
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.DataManager;
	import boxesandworlds.controller.UIManager;
	import boxesandworlds.gui.View;
	import com.flashdynamix.utils.SWFProfiler;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sah
	 */
	[SWF(width = "800", height = "800", frameRate = "30")]
	public class Main extends Sprite 
	{
		private var _canvas:View;
		
		public function Main():void 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				//stage.addEventListener(MouseEvent.RIGHT_CLICK, rightMouseDownHandler);
				
				init(stage.loaderInfo.parameters);
			}
		}
		
		public function init(params:Object):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			SWFProfiler.init(stage, this);
			
			initCore(params)
		}
		
		public function initCore(params:Object = null):void {			
			_canvas = new View;
			addChild(_canvas);
			
			Core.data = new DataManager(params);
			Core.ui = new UIManager(_canvas);
			Core.data.addEventListener(Event.COMPLETE, initCompleteHandler);
			Core.init();
		}
		
		private function initCompleteHandler(e:Event):void 
		{
			Core.ui.init();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function rightMouseDownHandler(e:MouseEvent):void 
		{
			
		}
		
	}
	
}