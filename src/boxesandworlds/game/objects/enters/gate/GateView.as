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
		private var _ui:Sprite;
		private var _gate:Gate;
		
		public function GateView(game:Game, gate:Gate) 
		{
			super(game, gate);
			_gate = gate;
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0x330066);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			_ui.alpha = 0.5;
			
			obj.data.views.push(_ui);
			obj.data.containerIds[0] = 0;
			super.init();
		}
		
		override public function step():void 
		{
			_ui.alpha = _gate.enterData.isOpen ? 0.5 : 1;
		}
	}

}