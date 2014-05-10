package boxesandworlds.game.objects.items.worldBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.ItemView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldBoxView extends ItemView
	{
		private var _ui:Sprite;
		
		public function WorldBoxView(game:Game, box:WorldBox) 
		{
			super(game, box);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0x000099);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			_ui.graphics.beginFill(0xFF00FF);
			_ui.graphics.drawRect(-obj.data.width / 6, -obj.data.height / 2, obj.data.width / 3, obj.data.height * 0.7);
			addChild(_ui);
		}
	}

}