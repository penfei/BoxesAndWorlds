package boxesandworlds.gui {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	/**
	 * ...
	 * @author Sah
	 */
	public class View extends Sprite {
		private var _enable:Boolean = true;
		
		public function View():void {
			
		}
		
		//properties		
		public function get enable():Boolean {
			return _enable;
		}
		
		public function loadImage(mc:MovieClip, url:String, online:Boolean = false):void {
			var request:URLRequest = new URLRequest(url);
			var context:LoaderContext = (online)
			? new LoaderContext(false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain)
			: null;

			var loader:Loader = new Loader();
			mc.container.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function loaderCompleteHandler(e:Event):void {
				if (loader.height != mc.mask_mc.height) {
					var percent:Number = mc.mask_mc.height / loader.height;

					var matrix:Matrix = new Matrix();
					matrix.scale(percent, percent);
					loader.transform.matrix = matrix;

					if (loader.width < mc.mask_mc.width) {
						percent = mc.mask_mc.width / loader.width;
						matrix.scale(percent, percent);
						loader.transform.matrix = matrix;
					}
				}
				loader.x = (mc.mask_mc.width - loader.width) / 2;
				loader.y = (mc.mask_mc.height - loader.height) / 2;
			});
			loader.load(request, context);
		}
		
		//public		
		public function load():void {	
			doLoadComplete();
		}
		
		public function setEnabled(enable:Boolean):void {
			_enable = enable;
			mouseChildren = enable;
			mouseEnabled = enable;
		}
		
		//protected
		public function setup():void {
			
		}
		
		protected function doHideAnimationComplete():void{
			dispatchEvent(new ViewEvent(ViewEvent.HIDE_ANIMATION_COMPLETE));
		}
		
		protected function doShowAnimationComplete():void{
			dispatchEvent(new ViewEvent(ViewEvent.SHOW_ANIMATION_COMPLETE));
		}
		
		protected function doLoadComplete():void{
			dispatchEvent(new ViewEvent(ViewEvent.LOAD_COMPLETE));
		}
	
	}

}