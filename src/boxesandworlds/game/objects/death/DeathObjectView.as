package boxesandworlds.game.objects.death 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	/**
	 * ...
	 * @author Sah
	 */
	public class DeathObjectView extends GameObjectView
	{
		private var _deathObject:DeathObject;
		
		public function DeathObjectView(game:Game, deathObject:DeathObject) 
		{
			_deathObject = deathObject;
			super(game, deathObject);
		}
		
	}

}