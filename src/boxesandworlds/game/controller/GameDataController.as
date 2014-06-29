package boxesandworlds.game.controller 
{
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.utils.XMLUtils;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Sah
	 */
	public class GameDataController extends Controller
	{
		private var _level:Class;
		private var _isTest:Boolean;
		private var _isGameOver:Boolean;
		private var _isPaused:Boolean;
		private var _isDestroyed:Boolean;
		
		private var _xmlLevelParams:XML;
		private var _xmlLevelObjects:Dictionary;
		private var _xmlLevelObjectsCountTotal:uint;
		private var _xmlLevelObjectsCountLoaded:uint;
		
		private var _params:Object;
		
		public function GameDataController(game:Game, params:Object) 
		{
			super(game);
			_params = params;
			
			//_level = params.level;			
			_isDestroyed = true;
		}
		
		override public function init():void 
		{
			_isGameOver = false;
			_isPaused = false;
			_isDestroyed = false;
			_isTest = true;
		}
		
		override public function step():void 
		{
			
		}
		
		override public function destroy():void 
		{
			_isDestroyed = true;
		}
		
		public function gameOver():void 
		{
			_isGameOver = true;
		}
		
		public function getLevel():Level {
			return new _level(game);
		}
		
		public function load():void 
		{
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
			
			if ( _xmlLevelParams.levelScript == null || _xmlLevelParams.levelScript.@scriptName == "" )
			{
				_level = Level;
			}
			else
			{
				try
				{
					_level = getDefinitionByName(_xmlLevelParams.levelScript.@scriptName) as Class;
				}
				catch (exception:Object)
				{
					_level = Level;
				}
			}
			
			_xmlLevelObjects = new Dictionary();
			_xmlLevelObjectsCountTotal = 0;
			_xmlLevelObjectsCountLoaded = 0;
			
			var downloadList:Vector.<String> = XMLUtils.findNodesByType( _xmlLevelParams, Attribute.URL );
			
			for each( var path:String in downloadList )
			{
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
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get level():Class {return _level;}	
		public function get isTest():Boolean { return _isTest; }
		public function get isDestroyed():Boolean {return _isDestroyed;}
		public function get isGameOver():Boolean {return _isGameOver;}
		public function get isPaused():Boolean {return _isPaused;}
		public function set isPaused(value:Boolean):void { _isPaused = value; }
		public function get xmlLevelParams():XML { return _xmlLevelParams; }
		public function get xmlLevelObjects():Dictionary { return _xmlLevelObjects; }
	}

}

import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.utils.Dictionary;

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