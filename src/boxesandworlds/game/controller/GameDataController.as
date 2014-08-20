package boxesandworlds.game.controller 
{
	import boxesandworlds.controller.Core;
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
		private var _xmlLevelObjectsCountTotal:uint;
		private var _xmlLevelObjectsCountLoaded:uint;
		
		private var _params:Object;
		
		public var completeParams:Object;
		
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
			//_isTest = true;
			_isTest = false;
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
			var urlL:URLLoader = new URLLoader();
			var urlR:URLRequest = new URLRequest(xmlLevelPath);
			
			urlL.addEventListener(Event.COMPLETE, onXmlLevelLoaded);
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
			
			_xmlLevelObjectsCountTotal = 0;
			_xmlLevelObjectsCountLoaded = 0;
			
			var downloadList:Vector.<String> = XMLUtils.findNodesByType( _xmlLevelParams, Attribute.URL );
			
			for each( var url:String in downloadList )
			{
				++_xmlLevelObjectsCountTotal;
				Core.content.load(url, onXmlContentLoaded);
			}
		} 
		
		public function onXmlContentLoaded():void
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
		public function get xmlLevelPath():String { return _params.xmlLevelPath; }
	}

}