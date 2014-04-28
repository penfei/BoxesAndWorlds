package boxesandworlds.gui.popup {
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
	public class Popup extends IdView {
		static private const TWEEN_DURATION:Number = 0.2;
		
		public function Popup(id:int):void {
			super(id);
		}
		
		//public
		public function enterEvent():void {
		
		}
		
		public function escapeEvent():void {
			hideAnimation();
		}
		
		//public
		override public function hideAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			super.hideAnimation(sec);
		}
		
		override public function showAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			super.showAnimation(sec);
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
		private function showAnimationCompleteHandler(e:TweenEvent):void {
			var tween:TweenMax = e.target as TweenMax;
			tween.removeEventListener(TweenEvent.COMPLETE, showAnimationCompleteHandler);
			doShowAnimationComplete();
		}
		
		private function hideAnimationCompleteHandler(e:TweenEvent):void {
			var tween:TweenMax = e.target as TweenMax;
			tween.removeEventListener(TweenEvent.COMPLETE, hideAnimationCompleteHandler);
			doHideAnimationComplete();
		}
	}
}