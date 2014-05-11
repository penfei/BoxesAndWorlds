package boxesandworlds.game.objects.items.teleportBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.ItemView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class TeleportBoxView extends ItemView
	{
		private var _ui:Sprite;
		
		public function TeleportBoxView(game:Game, box:TeleportBox) 
		{
			super(game, box);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0xFF0000);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			addChild(_ui);
		}
	}

}