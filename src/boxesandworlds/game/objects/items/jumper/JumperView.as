package boxesandworlds.game.objects.items.jumper 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.ItemView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class JumperView extends ItemView
	{
		private var _ui:Sprite;
		private var _jumper:Jumper;
		
		public function JumperView(game:Game, jumper:Jumper) 
		{
			_jumper = jumper;
			super(game, _jumper);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0x990033);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			
			obj.data.views.push(_ui);
			obj.data.containerIds[0] = 0;
			super.init();
		}	
	}

}