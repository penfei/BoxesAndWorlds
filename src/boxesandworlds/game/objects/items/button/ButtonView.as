package boxesandworlds.game.objects.items.button 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.ItemView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class ButtonView extends ItemView
	{
		private var _ui:Sprite;
		private var _button:Button;
		
		public function ButtonView(game:Game, button:Button) 
		{
			_button = button;
			super(game, button);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0xF3FF50);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			
			obj.data.views.push(_ui);
			obj.data.containerIds[0] = 0;
			super.init();
		}	
	}

}