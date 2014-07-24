package boxesandworlds.controller 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Sah
	 */
	public class ContentManager extends EventDispatcher
	{
		private var _library:Object;
		
		public function ContentManager() 
		{
			_library = new Object();
		}
		
		public function get library():Object { return _library; }
		
		public function hasItem(url:String):Boolean {
			return _library.hasOwnProperty(url);
		}
		
		public function hasLoadedItem(url:String):Boolean {
			return hasItem(url) && _library[url] != null;
		}
		
		public function load(url:String, callBack:Function = null):void {
			if(hasLoadedItem(url) && callBack != null) callBack();
			if (!hasItem(url)) {
				var loader:ContentLoader = new ContentLoader(_library);
				loader.load(url, callBack);
			}
		}		
	}

}

import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

class ContentLoader extends EventDispatcher
{
	private var _library:Object;
	private var _url:String;
	private var _callBack:Function;
	
	public function ContentLoader(library:Object):void
	{
		_library = library;
	}
	
	public function load(url:String, callBack:Function = null):void
	{
		_callBack = callBack;
		_url = url;
		_library[url] = null;
		
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onContentLoaded);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onContentNotLoaded);
		loader.load(new URLRequest( "../assets/" + url ));
	}
	
	private function onContentLoaded( e:Event ):void
	{
		_library[_url] = e.target.content;
		if (_callBack != null) _callBack();
	}
	
	private function onContentNotLoaded( e:IOErrorEvent ):void
	{
		trace(e.toString());
	}
}