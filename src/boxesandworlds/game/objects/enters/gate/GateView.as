package boxesandworlds.game.objects.enters.gate 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.EnterView;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class GateView extends EnterView
	{
		private var _gate:Gate;
		
		public function GateView(game:Game, gate:Gate) 
		{
			super(game, gate);
			_gate = gate;
		}
		
		override public function init():void {
			super.init();
		}
		
		override public function step():void 
		{
			for (var j:uint = 0; j < _gate.data.views.length; j++) {
				_gate.data.views[j].alpha = _gate.enterData.isOpen ? 0.5 : 1;
			}
		}
	}

}