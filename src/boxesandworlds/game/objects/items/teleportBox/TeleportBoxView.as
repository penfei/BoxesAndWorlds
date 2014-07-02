package boxesandworlds.game.objects.items.teleportBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.ItemView;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sah
	 */
	public class TeleportBoxView extends ItemView
	{
		private var _ui:Sprite;
		private var _hintContainer:Sprite;
		
		public function TeleportBoxView(game:Game, box:TeleportBox) 
		{
			super(game, box);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0xFF0000);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			
			_hintContainer = new Sprite();
			_hintContainer.graphics.beginFill(0xCC9900);
			_hintContainer.graphics.drawCircle(0, 0, 5);
			_hintContainer.alpha = 0;
			_ui.addChild(_hintContainer);
			
			obj.data.views.push(_ui);
			obj.data.containerIds[0] = 0;
			super.init();
		}
		
		override public function showHintTeleport():void 
		{
			_hintContainer.alpha = 1;
			TweenLite.killTweensOf(_hintContainer);
			TweenLite.to(_hintContainer, 1, { alpha:0 } );
		}
	}

}