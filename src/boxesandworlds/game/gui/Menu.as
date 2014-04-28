package boxesandworlds.game.gui 
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.UIManager;
	import boxesandworlds.game.controller.Game;
	import com.greensock.TweenMax;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import symbols.game.GameMenuUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class Menu extends Sprite
	{
		private var _game:Game;
		private var _ui:GameMenuUI;
		
		public function Menu(game:Game) 
		{
			_game = game;
		}
		
		public function init():void 
		{
			_ui = new GameMenuUI;
			cacheAsBitmap = true;
			addChild(_ui);
			
			resize();
			
			_ui.btnRestart.buttonMode = _ui.btnBack.buttonMode = true;
			_ui.btnRestart.addEventListener(MouseEvent.CLICK, restartClickHandler);
			_ui.btnBack.addEventListener(MouseEvent.CLICK, backClickHandler);
		}
		
		private function backClickHandler(e:MouseEvent):void 
		{
			_game.back()
		}
		
		private function restartClickHandler(e:MouseEvent):void 
		{
			_game.start();
		}
		
		public function step():void 
		{			
			
		}
		
		public function resize():void 
		{
			_ui.btnRestart.x = _game.gui.stageWidth - 66;
			_ui.btnRestart.y = _game.stage.stageHeight - 60;
			_ui.btnBack.x = _game.gui.stageWidth - 188;
			_ui.btnBack.y = _game.stage.stageHeight - 63;
		}
		
		public function showGameOver(isName:Boolean = true):void 
		{
			
		}		
	}

}