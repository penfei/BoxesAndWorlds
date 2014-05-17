package boxesandworlds.game.objects.door 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class DoorView extends GameObjectView
	{
		private var _ui:Sprite;
		
		public function DoorView(game:Game, door:Door) 
		{
			super(game, door);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0xF30230);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			addChild(_ui);
		}
		
		public function showOpen():void 
		{
			_ui.alpha = 0.5;
		}
		
		public function showClose():void 
		{
			_ui.alpha = 1;
		}
		
	}

}