package boxesandworlds.game.controller 
{
	import boxesandworlds.game.gui.Menu;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.world.WorldData;
	import boxesandworlds.gui.View;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import nape.geom.Vec2;
	import nape.phys.BodyList;
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
		private var _layers:Vector.<Sprite>;
		
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
		public function get layers():Vector.<Sprite> {return _layers;}
		
		override public function init():void 
		{
			_canvas = new View;
			game.addChild(_canvas);
			
			_mainContainer = new Sprite();
			_canvas.addChild(_mainContainer);
			
			_layers = game.level.getLayers();
			for each(var layer:Sprite in _layers) _mainContainer.addChild(layer);
			
			_debug = new BitmapDebug(stageWidth, stageHeight, game.stage.color, true);
			_debug.drawConstraints = true;
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
		
		public function get mousePoint():Vec2 { return Vec2.get(container.x + game.stage.mouseX, container.y + game.stage.mouseY); }
		
		public function getItemUnderPoint():Item {
			var bodyList:BodyList = game.physics.world.bodiesUnderPoint(mousePoint, null, bodyList);
			var item:Item;
			for (var i:int = 0; i < bodyList.length; i++) {
				item = bodyList.at(i).userData.obj as Item;
				if (item != null && item.itemData.canTelekinesis && item != game.objects.me.item && item != game.objects.me.telekinesisItem) {
					return item;
				}
			}
			return null;
		}
	}

}