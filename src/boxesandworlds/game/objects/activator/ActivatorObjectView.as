package boxesandworlds.game.objects.activator 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	/**
	 * ...
	 * @author Sah
	 */
	public class ActivatorObjectView extends GameObjectView
	{
		private var _activatorObject:ActivatorObject;
		
		public function ActivatorObjectView(game:Game, activatorObject:ActivatorObject) 
		{
			_activatorObject = activatorObject;
			super(game, activatorObject);
		}
		
	}

}