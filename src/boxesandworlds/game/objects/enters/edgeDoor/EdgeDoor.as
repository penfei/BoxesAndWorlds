package boxesandworlds.game.objects.enters.edgeDoor 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.world.World;
	/**
	 * ...
	 * @author Sah
	 */
	public class EdgeDoor extends Enter
	{
		private var _view:EdgeDoorView;
		private var _properties:EdgeDoorData;
		
		public function EdgeDoor(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object = null):void {
			data = new EdgeDoorData(game);
			enterData = data as EnterData; 
			_properties = data as EdgeDoorData;
			_properties.init(params);
			
			_view = new EdgeDoorView(game, this);
			enterView = _view;
			view = _view;
			
			super.init();
		}
		
		override protected function checkOpenAvailability():Boolean {
			if (world == null) return false;
			if (world.worldBox == null) return false;
			var w:World = world.getConnectedWorldByEdge(enterData.edge);
			if (w != null) {
				if (w.getEnterByEdge(w.getEdgeByWorld(world)) == null) return false;
			} else return false;
			return true;
		}
	}

}