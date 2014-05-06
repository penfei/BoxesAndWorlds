package boxesandworlds.game.controller 
{
	import boxesandworlds.game.gui.Menu;
	import boxesandworlds.game.world.WorldData;
	import boxesandworlds.gui.View;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import nape.geom.Vec2;
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
		public function get debug():Debug {return _debug;}
		
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
			var data:WorldData = game.objects.me.world.data;
			container.x = -data.axis.x + data.width / 2;
			container.y = -data.axis.y + data.height / 2;
			
			if (game.data.isTest) {
				_debug.clear();
				_debug.draw(game.physics.world);
				//_debug.drawAABB(game.objects.me.itemArea, 0xff00ff);
				_debug.flush();
				_debug.transform.tx = container.x;
				_debug.transform.ty = container.y;
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