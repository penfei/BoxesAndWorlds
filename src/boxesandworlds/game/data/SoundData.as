package boxesandworlds.game.data 
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.data.MusicData;
	import boxesandworlds.game.controller.Game;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Sah
	 */
	public class SoundData extends EventDispatcher
	{
		private var _musicData:MusicData;
		private var _game:Game;
		private var _chanel:SoundChannel;
		
		public function SoundData(game:Game, music:MusicData) 
		{
			_game = game;
			_musicData = music;
		}
		
		public function init():void 
		{
			
		}
		
		public function play():void 
		{
			_chanel = data.sound.play(0, 0, new SoundTransform(Core.data.volumeMusic));
			_chanel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		public function update(timer:uint):void 
		{
			
		}
		
		public function stop():void 
		{
			if(_chanel){
				_chanel.stop();
				_chanel = null;
			}
		}
		
		public function updateVolume():void 
		{
			_chanel.soundTransform = new SoundTransform(Core.data.volumeSound);
		}
		
		private function soundCompleteHandler(e:Event):void 
		{
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
		
		public function get data():MusicData {return _musicData;}
		
	}

}