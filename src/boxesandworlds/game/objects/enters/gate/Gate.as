package boxesandworlds.game.objects.enters.gate 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.enters.EnterData;
	/**
	 * ...
	 * @author Sah
	 */
	public class Gate extends Enter
	{
		private var _view:GateView;
		private var _properties:GateData;
		
		public function Gate(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object = null):void {
			data = new GateData(game);
			enterData = data as EnterData; 
			_properties = data as GateData;
			_properties.init(params);
			
			_view = new GateView(game, this);
			enterView = _view;
			view = _view;
			
			super.init();
		}
	}

}