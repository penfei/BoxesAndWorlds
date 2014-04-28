package boxesandworlds.game.controller 
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.game.data.SoundData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import sounds.bullet.*;
	import sounds.boom.*;
	import sounds.jump.*;
	import sounds.kills.*;
	import sounds.sword.*;
	import sounds.walk.*;
	/**
	 * ...
	 * @author Sah
	 */
	public class SoundController extends Controller
	{
		private var _offsetTimer:uint;
		private var _songs:Vector.<SoundData>;
		private var _playlist:Vector.<SoundData>;
		private var _currentSong:SoundData;
		private var _walkingChanel:SoundChannel;
		private var _walkingSoundLength:uint;
		private var _random:uint;
		private var _isLoad:Boolean;
		
		public function SoundController(game:Game) 
		{
			super(game);
		}
		
		public function load():void 
		{
			_songs = new Vector.<SoundData>;
			
			for each(var song:SoundData in _songs) {
				if (song.data.isLoad) {
					_isLoad = true;
					dispatchEvent(new Event(Event.COMPLETE));
					break;
				}
			}
			//if (!_isLoad) {
				//Core.data.loadedMusic.addEventListener(Event.COMPLETE, loadCompleteHandler);
			//}
			loadCompleteHandler();
		}
		
		private function loadCompleteHandler(e:Event = null):void 
		{
			_isLoad = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function init():void 
		{
			//for each(var song:SoundData in _songs) {
				//song.init()
			//}		
			//
			//createPlaylist();
			//
			//play();
		}
		
		private function createPlaylist():void 
		{
			_playlist = new Vector.<SoundData>;
			
			for each(var song:SoundData in _songs) {
				_playlist.push(song);
			}
			
			_playlist.sort(shuffleVector);
		}
		
		private function shuffleVector( a:Object, b:Object ):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		private function play():void {
			_offsetTimer = getTimer();
			
			_random = Math.random() * _playlist.length / 2;
			_currentSong = _playlist[_random];
			_playlist.splice(_random, 1);
			_playlist.push(_currentSong);
			if(_currentSong.data.isLoad){
				_currentSong.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_currentSong.play();
			} else play()
		}
		
		private function soundCompleteHandler(e:Event):void 
		{
			play();
		}
		
		override public function step():void 
		{
			var timer:uint = getTimer() - _offsetTimer;
			
			//_currentSong.update(timer);
			
			if (_walkingChanel) {
				if (_walkingChanel.position > _walkingSoundLength * 0.5) {
					_walkingChanel = null;
				}
			}
		}	
		
		override public function destroy():void 
		{
			//_currentSong.stop()
		}
		
		public function walking():void {
			if (!_walkingChanel) {
				_random = Math.random() * 4;
				var s:Sound;
				if (_random == 0) s = new Walk1;
				if (_random == 1) s = new Walk4;
				if (_random == 2) s = new Walk5;
				if (_random == 3) s = new Walk6;
				_walkingSoundLength = s.length;
				_walkingChanel = s.play(0, 0, new SoundTransform(Core.data.volumeSound));
			}
		}
		
		public function kill(hit:uint):void {
			if (hit == 2) new Double().play(0, 0, new SoundTransform(Core.data.volumeSound));
			else if (hit == 3) new Triple().play(0, 0, new SoundTransform(Core.data.volumeSound));
			else if (hit == 4) new Mega().play(0, 0, new SoundTransform(Core.data.volumeSound));
			else if (hit > 4) new Ultra().play(0, 0, new SoundTransform(Core.data.volumeSound));
		}
		
		public function bullet():void {
			_random = Math.random() * 3;
			if (_random == 0) new Bullet1().play(0, 0, new SoundTransform(Core.data.volumeSound));
			if (_random == 1) new Bullet2().play(0, 0, new SoundTransform(Core.data.volumeSound));
			if (_random == 2) new Bullet3().play(0, 0, new SoundTransform(Core.data.volumeSound));
		}
		
		public function boom():void {
			_random = Math.random() * 3;
			if (_random == 0) new Boom1().play(0, 0, new SoundTransform(Core.data.volumeSound * 0.7));
			if (_random == 1) new Boom2().play(0, 0, new SoundTransform(Core.data.volumeSound));
			if (_random == 2) new Boom3().play(0, 0, new SoundTransform(Core.data.volumeSound));
		}
		
		public function jump():void {
			_random = Math.random() * 2;
			if (_random == 0) new Jump1().play(0, 0, new SoundTransform(Core.data.volumeSound));
			if (_random == 1) new Jump2().play(0, 0, new SoundTransform(Core.data.volumeSound));
		}
		
		public function sword(distance:Number):void {
			if (distance < 200) {
				_random = Math.random() * 4;
				if (_random == 0) new Sword1().play(0, 0, new SoundTransform(Core.data.volumeSound));
				if (_random == 1) new Sword5().play(0, 0, new SoundTransform(Core.data.volumeSound));
				if (_random == 2) new Sword2().play(0, 0, new SoundTransform(Core.data.volumeSound));
				if (_random == 3) new Sword3().play(0, 0, new SoundTransform(Core.data.volumeSound));
			} else {
				_random = Math.random() * 4;
				if (_random == 0) new Sword4().play(0, 0, new SoundTransform(Core.data.volumeSound));
				if (_random == 1) new Sword7().play(0, 0, new SoundTransform(Core.data.volumeSound));
				if (_random == 2) new Sword8().play(0, 0, new SoundTransform(Core.data.volumeSound));
				if (_random == 3) new Sword6().play(0, 0, new SoundTransform(Core.data.volumeSound));
			}
		}
		
		public function updateVolume():void 
		{
			//_currentSong.updateVolume();
		}
		
		public function get isLoad():Boolean {return _isLoad;}
	}

}