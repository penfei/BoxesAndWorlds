package boxesandworlds.game.levels.level1
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.objects.items.button.Button;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	/**
	 * @author Alexey
	 */
	public class Level1 extends Level
	{		
		public function Level1(game:Game):void
		{
			super(game);
		}
		
		static public function layers():Vector.<Sprite> {
			var arr:Vector.<Sprite> = Level.layers();
			
			var heroLayer:Sprite = arr[0];
			var glow:GlowFilter = new GlowFilter(0x339933, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, false);
			heroLayer.filters = [glow];
			
			return arr;
		}
		
		override public function getLayers():Vector.<Sprite> {
			return layers();
		}
		
		override public function init():void {
			super.init();
			
			game.gui.offsetY = 0.3;
			TweenMax.to(game.objects.me.playerView.ui, 0, {colorTransform:{tint:0x000000, tintAmount:1}});
		}
		
		override public function start():void 
		{
			
		}
		
		override public function destroy():void {
			
		}
		
		override public function gameOver():void 
		{
			
		}
		
		override public function step():void 
		{
			
		}	
	}

}