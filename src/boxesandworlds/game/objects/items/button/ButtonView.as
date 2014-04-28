package boxesandworlds.game.objects.items.button 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class ButtonView extends GameObjectView
	{
		private var _ui:Sprite;
		private var _button:Button;
		
		public function ButtonView(game:Game, button:Button, ui:Sprite) 
		{
			_button = button;
			_ui = ui;
			super(game, button);
		}
		
		override public function init():void {
			_ui.x = 0;
			_ui.y = 0;
			
			cacheAsBitmap = true;
			addChild(_ui);
		}
		
		public function destroy():void 
		{
			removeChildren();
			_ui = null;
		}		
	}

}