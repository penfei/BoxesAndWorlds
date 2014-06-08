package boxesandworlds.game.controller 
{
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.gui.View;
	import boxesandworlds.gui.ViewEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import utils.xml.XMLUtils;
	/**
	 * ...
	 * @author Sah
	 */
	public class Game extends View
	{
		static public const BACK:String = "BACK";
		static public const GAME_COMPLETE:String = "GAME_COMPLETE";
		
		private var _data:GameDataController;
		private var _level:Level;
		private var _input:InputController;
		private var _physics:PhysicsController;
		private var _gui:GuiController;
		private var _objects:ObjectsController;
		private var _sound:SoundController;
		
		private var _params:Object;
		private var _xmlLevelParams:XML;
		private var _xmlLevelObjects:Dictionary;
		private var _xmlLevelObjectsCountTotal:uint;
		private var _xmlLevelObjectsCountLoaded:uint;
		
		public function Game() 
		{
			
		}
		
		public function get data():GameDataController {return _data;}
		public function get physics():PhysicsController { return _physics; }
		public function get gui():GuiController {return _gui;}
		public function get level():Level {return _level;}
		public function get input():InputController {return _input;}
		public function get objects():ObjectsController {return _objects;}
		public function get sound():SoundController { return _sound; }
		
		public function init(params:Object):void {
			_params = params;
		}
		
		override public function load():void {		
			var xmlLevelFileName:String = _params.xmlLevelPath;
			var urlL:URLLoader = new URLLoader();
			var urlR:URLRequest = new URLRequest(xmlLevelFileName);
			
			urlL.addEventListener(Event.COMPLETE, onXmlLevelLoaded);
			urlL.addEventListener(IOErrorEvent.IO_ERROR, onXmlLevelNotLoaded);
			urlL.load(urlR);
		}
		
		public function onXmlLevelLoaded(e:Event):void
		{
			_xmlLevelParams = XML(e.target.data);
			
			_xmlLevelObjects = new Dictionary();
			_xmlLevelObjectsCountTotal = 0;
			_xmlLevelObjectsCountLoaded = 0;
			
			var xmlUrlList:XMLList = XMLUtils.findNodesByName( _xmlLevelParams, "physicsBitmapDataUrl" );
			xmlUrlList += XMLUtils.findNodesByName(_xmlLevelParams, "viewURLs");
			
			//for each( var it:XML in xml.children() )
			//{
			//	trace(it.name());
			//	trace(it);
			//	trace("_-_-_-_");
			//}
			for each( var it:XML in xmlUrlList )
			{
				//	trace(it.name());
				//	trace(it.@value);
				//	trace("---");
				var path:String = (it.@value).toString();
				_xmlLevelObjects[ path ] = null;
			}
			
			for (var k:Object in _xmlLevelObjects) 
			{
				var contentLoader:XMLContentLoader = new XMLContentLoader(_xmlLevelObjects);
				contentLoader.addEventListener(Event.COMPLETE, onXmlContentLoaded);
				contentLoader.addEventListener(IOErrorEvent.IO_ERROR, onXmlContentNotLoaded);
				contentLoader.load( (k as String) );
				
				++_xmlLevelObjectsCountTotal;
			}
		} 
		public function onXmlLevelNotLoaded(e:IOErrorEvent):void
		{
			trace(e.toString());
		}
		
		public function onXmlContentLoaded( e:Event ):void
		{
			++_xmlLevelObjectsCountLoaded;
			checkLoadedContentAndInitXml();
		}
		
		public function onXmlContentNotLoaded( e:IOErrorEvent ):void
		{
			++_xmlLevelObjectsCountLoaded;		
			checkLoadedContentAndInitXml();
		}
		
		public function checkLoadedContentAndInitXml():void
		{
			if (_xmlLevelObjectsCountLoaded == _xmlLevelObjectsCountTotal)
			{
				_data = new GameDataController(this, _xmlLevelParams);
				_level = _data.getLevel();

				_sound = new SoundController(this);
				_sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
				_sound.load();

				_level.addEventListener(ViewEvent.LOAD_COMPLETE, loadCompleteHandler);
				_level.load();
			}
		}
		
		public function start():void {
			destroy();
			
			_data.init();
			
			_gui = new GuiController(this);
			_gui.init();
			
			_physics = new PhysicsController(this);
			_physics.init();
			
			_level.init();
			
			_objects = new ObjectsController(this);
			_objects.init()
			
			_input = new InputController(this);
			_input.init();
			
			_sound.init();
			
			_level.start();
			
			if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function gameOver(label:String = ""):void 
		{
			if(!_data.isGameOver){
				_data.gameOver();
				_input.destroy();
				_level.gameOver();
				trace("game over " + label);
			}
		}
		
		public function resize():void 
		{
			
		}
		
		public function back():void 
		{
			destroy();
			dispatchEvent(new Event(BACK));
		}
		
		public function complete():void 
		{
			destroy();
			dispatchEvent(new Event(GAME_COMPLETE));
		}
		
		public function destroy():void {
			if (!_data.isDestroyed) {
				_gui.destroy();
				_input.destroy();
				_sound.destroy();
				_physics.destroy();
				_level.destroy();
				_objects.destroy();
				_data.destroy();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function loadCompleteHandler(e:Event):void {
			if (_sound.isLoad && _level.isLoad) doLoadComplete();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (!_data.isPaused) {
				_data.step();
				_level.step();
				_objects.step();
				_sound.step();
				_gui.step();
				_physics.step();
			}
		}
		
	}
}
import flash.display.Loader;
import flash.events.EventDispatcher;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;

class XMLContentLoader extends EventDispatcher
{
	private var _dict:Dictionary;
	private var _path:String;
	
	public function XMLContentLoader( dict:Dictionary ):void
	{
		_dict = dict;
	}
	public function load(path:String):void
	{
		_path = path;
		
		var url:URLRequest = new URLRequest( "../assets/" + path );
		var img:Loader = new Loader();
		img.load(url);
		img.contentLoaderInfo.addEventListener(Event.COMPLETE, onContentLoaded);
		img.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onContentNotLoaded);
	}
			
	public function onContentLoaded( e:Event ):void
	{
		_dict[_path] = e.target.content;
		dispatchEvent( e );
	}
	
	public function onContentNotLoaded( e:IOErrorEvent ):void
	{
		dispatchEvent(e);
	}
}