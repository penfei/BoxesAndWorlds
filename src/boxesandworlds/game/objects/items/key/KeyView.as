package boxesandworlds.game.objects.items.key 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.ItemView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class KeyView extends ItemView
	{
		private var _ui:Sprite;
		
		public function KeyView(game:Game, key:Key) 
		{
			super(game, key);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.lineStyle(3, 0xF30230);
			_ui.graphics.moveTo( -obj.data.width / 2, obj.data.height / 2);
			_ui.graphics.lineTo( obj.data.width / 2, -obj.data.height / 2);
			addChild(_ui);
		}
	}

}