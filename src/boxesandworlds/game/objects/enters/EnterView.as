package boxesandworlds.game.objects.enters 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.EnterView;
	import boxesandworlds.game.objects.GameObjectView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class EnterView extends GameObjectView
	{
		private var _ui:Sprite;
		
		public function EnterView(game:Game, enter:Enter) 
		{
			super(game, enter);
		}
	}

}