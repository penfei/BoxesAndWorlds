package boxesandworlds.game.objects.items.box 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.ItemView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class BoxView extends ItemView
	{
		private var _ui:Sprite;
		
		public function BoxView(game:Game, box:Box) 
		{
			super(game, box);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0xfef7af);
			_ui.graphics.drawRect( -obj.data.width / 2 - 1, -obj.data.height / 2 - 1, obj.data.width + 2, obj.data.height + 2);
			
			obj.data.views.push(_ui);
			obj.data.containerIds[0] = 0;
			super.init();
		}
		
	}

}