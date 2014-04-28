package boxesandworlds.game.controller 
{
	import boxesandworlds.game.gui.Menu;
	import boxesandworlds.gui.View;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	/**
	 * ...
	 * @author Sah
	 */
	public class GuiController extends Controller
	{
		private var _debug:Debug;
		private var _canvas:View;
		private var _mainContainer:Sprite;
		private var _showedView:View;
		private var _menu:Menu;
		
		public function GuiController(game:Game) 
		{
			super(game);
		}
		
		public function get canvas():View { return _canvas; }
		public function get container():Sprite { return _mainContainer; }
		public function get menu():Menu {return _menu;}
		public function get stageWidth():Number { return _canvas.stage.stageWidth }
		public function get stageHeight():Number { return _canvas.stage.stageHeight}
		
		override public function init():void 
		{
			_canvas = new View;
			game.addChild(_canvas);
			
			_mainContainer = new Sprite();
			_canvas.addChild(_mainContainer);
			
			_debug = new BitmapDebug(stageWidth, stageHeight, game.stage.color, true);
            if (game.data.isTest) _canvas.addChild(_debug.display);
			
			_menu = new Menu(game);
			_canvas.addChild(_menu);
			_menu.init();
		}
		
		override public function step():void {
			_showedView = game.objects.me.view;
			TweenLite.to(container, 0.5, { x: -_showedView.x + stageWidth / 2, y: -_showedView.y + stageHeight * 0.7 } );
			
			if (game.data.isTest) {
				_debug.clear();
				_debug.draw(game.physics.world);
				_debug.flush();
				_debug.transform.tx = -_showedView.x + stageWidth / 2;
				_debug.transform.ty = -_showedView.y + stageHeight * 0.7;
			}
			
			_menu.step();
		}
		
		override public function destroy():void {
			game.removeChild(_canvas);
			_canvas = null;
			_mainContainer = null;
		}
	}

}