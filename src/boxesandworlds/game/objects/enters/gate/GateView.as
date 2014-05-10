package boxesandworlds.game.objects.enters.gate 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.EnterView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class GateView extends EnterView
	{
		private var _ui:Sprite;
		
		public function GateView(game:Game, gate:Gate) 
		{
			super(game, gate);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0x330066);
			_ui.graphics.drawRect(-obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height); 
			addChild(_ui);
		}
	}

}