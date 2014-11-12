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
		private var _jumper:Jumper;
		
		public function JumperView(game:Game, jumper:Jumper) 
		{
			_jumper = jumper;
			super(game, _jumper);
		}
		
		override public function init():void {
			super.init();
		}	
	}

}