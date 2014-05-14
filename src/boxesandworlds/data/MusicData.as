package boxesandworlds.data 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Sah
	 */
	public class MusicData extends EventDispatcher
	{
		private var _url:String;
		private var _sound:Sound;
		private var _isLoad:Boolean;
		
		public function MusicData(url:String) 
		{
			_url = url;
			_isLoad = false;
		}
		
		public function load():void 
		{
			_sound = new Sound;
			_sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
			//_sound.load(new URLRequest("http://stas.snpdev.ru/music/" + _url + "?noCache=" + String(Math.random())));
			_sound.load(new URLRequest("http://stas.snpdev.ru/music/" + _url));
			//_sound.load(new URLRequest(_url));
		}
		
		private function loadCompleteHandler(e:Event):void 
		{
			_isLoad = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get sound():Sound {return _sound;}
		public function get isLoad():Boolean {return _isLoad;}
		
	}

}