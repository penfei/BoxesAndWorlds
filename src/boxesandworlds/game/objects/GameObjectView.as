package boxesandworlds.game.objects 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.gui.View;
	/**
	 * ...
	 * @author Sah
	 */
	public class GameObjectView extends View
	{
		protected var game:Game;
		protected var obj:GameObject;
		
		public function GameObjectView(game:Game, obj:GameObject) 
		{
			this.obj = obj;
			this.game = game;
		}
		
		public function init():void {
			
		}
		
		public function step():void 
		{
			
		}
		
		public function showHintTeleport():void 
		{
			
		}
		
	}

}