package boxesandworlds.gui.page {
	import com.greensock.TweenMax;
	import com.greensock.events.TweenEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import boxesandworlds.gui.IdView;
	import boxesandworlds.controller.UIManager;
	
	/**
	 * ...
	 * @author Sah
	 */
	public class Page extends IdView {
		static private const TWEEN_DURATION:Number = 0.2;
		
		public function Page(id:int):void {
			super(id);
		}
		
		//public
		public function resize():void {
			
		}
		
		override public function hideAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			super.hideAnimation(sec);
			doHideAnimationComplete();
		}
		
		override public function showAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			super.showAnimation(sec);
			doShowAnimationComplete();
		}
		
		//protected
		protected function doHideAnimation(ui:Sprite, sec:Number):void {
			var tween:TweenMax = TweenMax.to(ui, TWEEN_DURATION, {alpha: 0});
			tween.addEventListener(TweenEvent.COMPLETE, hideAnimationCompleteHandler)
		}
		
		protected function doShowAnimation(ui:Sprite, sec:Number):void {
			var tween:TweenMax = TweenMax.to(ui, TWEEN_DURATION, {alpha: 1});
		    tween.addEventListener(TweenEvent.COMPLETE, showAnimationCompleteHandler);
		}
		
		//handlers		
		private function showAnimationCompleteHandler(e:TweenEvent):void 
		{
			var tween:TweenMax = e.target as TweenMax;
			tween.removeEventListener(TweenEvent.COMPLETE, showAnimationCompleteHandler);
			doShowAnimationComplete();
		}
	
		private function hideAnimationCompleteHandler(e:TweenEvent):void 
		{
			var tween:TweenMax = e.target as TweenMax;
			tween.removeEventListener(TweenEvent.COMPLETE, hideAnimationCompleteHandler);
			doHideAnimationComplete();
		}
	
	}
}