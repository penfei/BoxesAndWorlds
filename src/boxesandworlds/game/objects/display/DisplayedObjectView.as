package boxesandworlds.game.objects.display 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	/**
	 * ...
	 * @author Sah
	 */
	public class DisplayedObjectView extends GameObjectView
	{
		private var _displayedObject:DisplayedObject;
		
		public function DisplayedObjectView(game:Game, displayedObject:DisplayedObject) 
		{
			_displayedObject = displayedObject;
			super(game, displayedObject);
		}
		
	}

}