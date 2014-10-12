package boxesandworlds.game.levels.level1
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.objects.items.button.Button;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
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
			var glow:GlowFilter = new GlowFilter(0x339933, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, false);
			var glow2:GlowFilter = new GlowFilter(0x339933, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, true);
			var blur:BlurFilter = new BlurFilter(0, 56, 3);
			var blur2:BlurFilter = new BlurFilter(0, 14);
			
			arr[10].filters = [glow];
			arr[11].filters = [glow, blur2];
			arr[12].filters = [glow2, blur2];
			arr[13].filters = [glow2, blur2];
			arr[14].filters = [glow, blur2];
			arr[15].filters = [glow2, blur2];
			
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