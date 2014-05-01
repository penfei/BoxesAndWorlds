package boxesandworlds.game.objects.worldstructrure 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldStructureView extends GameObjectView
	{
		private var _structure:WorldStructure;
		
		public function WorldStructureView(game:Game, structure:WorldStructure) 
		{
			_structure = structure;
			super(game, structure);
		}
		
	}

}