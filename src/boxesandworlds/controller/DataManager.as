package boxesandworlds.controller {
	import boxesandworlds.data.BawUser;
	import boxesandworlds.data.MusicData;
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.level0.Level0;
	import boxesandworlds.game.levels.tutorial.TutorialLevel;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class DataManager extends EventDispatcher{
		static public const SERVER_URL:String = "http://clush.ru/";
		static public const LEVELS:Array = [TutorialLevel, Level0];
		//static public const SERVER_URL:String = "";
		
		private var _so:SharedObject;
		private var _save:SharedObject;
		private var _saveObject:Object;
		private var _volumeSound:Number;
		private var _volumeMusic:Number;
		private var _params:Object;
		private var _me:BawUser;
		private var _isSocial:Boolean;
		private var _game:Game;
		private var _musics:Vector.<MusicData>;
		private var _loadedMusic:MusicData;

		public function DataManager(params:Object) {
			_params = params;
		}
		
		public function get so():SharedObject {return _so;}
		public function get volumeSound():Number {return _volumeSound;}
		public function set volumeSound(value:Number):void {_volumeSound = value;}
		public function get volumeMusic():Number {return _volumeMusic;}
		public function set volumeMusic(value:Number):void {_volumeMusic = value;}
		public function get isSocial():Boolean {return _isSocial;}
		public function get me():BawUser {return _me;}
		public function set me(value:BawUser):void { _me = value; }
		public function get musics():Vector.<MusicData> {return _musics;}
		public function get loadedMusic():MusicData {return _loadedMusic;}
		public function get save():SharedObject {return _save;}
		
		public function init():void 
		{
			_volumeSound = 1;
			_volumeMusic = 0;
			_so = SharedObject.getLocal("boxandworlds");
			_save = SharedObject.getLocal("boxandworldssave");
			//_save.clear();
			if (_save.data.save1 == null) _saveObject = {};
			else _saveObject = JSON.parse(_save.data.save1);
			
			_musics = new Vector.<MusicData>;
			loadMusic();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function saveLevel():void {
			_game.saveLevel(_saveObject);
			_save.data.save1 = JSON.stringify(_saveObject);
		}
		
		public function loadLevel():void {
			
		}
		
		public function saveName(text:String):void 
		{
			_me.name = text;
			_so.data.name = text;
		}
		
		public function setGame(game:Game):void 
		{
			_game = game;
		}
		
		private function loadComplete(e:Event):void 
		{
			if (_game) {
				Core.ui.hidePreloader();
				_game.destroy();
				_game = null;
				//Core.ui.showPage(UIManager.RAITING_PAGE_ID);
			}
		}
		
		private function loadMusic(e:Event = null):void 
		{
			var mus:Vector.<MusicData> = new Vector.<MusicData>;
			for (var i:uint = 0; i < _musics.length; i++) {
				if (!_musics[i].isLoad) mus.push(_musics[i]);
			}
			if(mus.length){
				var r:uint = Math.random() * mus.length;
				mus[r].addEventListener(Event.COMPLETE, loadMusic);
				mus[r].load();
				_loadedMusic = mus[r];
			} else {
				_loadedMusic = null;
			}
		}

	}
}
