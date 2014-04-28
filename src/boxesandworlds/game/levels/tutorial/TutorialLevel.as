package boxesandworlds.game.levels.tutorial 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.objects.items.button.Button;
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
		public function TutorialLevel(game:Game) 
		{
			super(game);
		}
		
		override public function init():void {
			super.init();
			
			game.physics.world.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, game.physics.buttonType, game.physics.movableType, buttonContactHandler));
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
		
		private function buttonContactHandler(e:InteractionCallback):void 
		{
			var button:Button = e.int1.userData.obj as Button;
			
		}		
	}

}