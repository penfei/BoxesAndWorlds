package boxesandworlds.game.levels.tutorial 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.objects.items.button.Button;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	/**
	 * ...
	 * @author Sah
	 */
	public class TutorialLevel extends Level
	{
		private var _lines:Lines;
		public function TutorialLevel(game:Game) 
		{
			super(game);
		}
		
		static public function layers():Vector.<Sprite> {
			var arr:Vector.<Sprite> = Level.layers();
			
			var heroLayer:Sprite = arr[0];
			var glow:GlowFilter = new GlowFilter(0x435570, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, false);
			heroLayer.filters = [glow];
			
			return arr;
		}
		
		override public function getLayers():Vector.<Sprite> {
			return layers();
		}
		
		override public function init():void {
			super.init();
			
			data = new TutorialLevelData();
			
			_lines = new Lines();
			game.gui.canvas.addChildAt(_lines, 0);
			//game.physics.world.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, game.physics.buttonType, game.physics.movableType, buttonContactHandler));
		}
		
		override public function start():void 
		{
			
		}
		
		override public function destroy():void {
			_lines.destroy();
		}
		
		override public function gameOver():void 
		{
			
		}
		
		override public function step():void 
		{
			
		}
		
		private function buttonContactHandler(e:InteractionCallback):void 
		{
			var button:Button = e.int1.userData.obj as Button;
			
		}		
	}

}