package boxesandworlds.gui.page {
	import boxesandworlds.controller.DataManager;
	import boxesandworlds.gui.control.VolumePlace;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.UIManager;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import symbols.view.MainPageUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class MainPage extends Page
	{
		private var _ui:MainPageUI;
		private var _volsSounds:Vector.<VolumePlace>
		private var _volsMusic:Vector.<VolumePlace>
		
		public function MainPage() 
		{
			super(UIManager.MAIN_PAGE_ID);
		}
		
		override public function setup():void {
			_ui = new MainPageUI();
			
			_ui.btnGame.buttonMode = _ui.btnVolume.buttonMode = _ui.btnMusic.buttonMode = _ui.btnEditor.buttonMode = true;
			_ui.btnGame.addEventListener(MouseEvent.CLICK, gameClickHandler);
			_ui.btnVolume.addEventListener(MouseEvent.CLICK, btnVolumeClickHandler);
			_ui.btnMusic.addEventListener(MouseEvent.CLICK, btnMusicClickHandler);
			_ui.btnEditor.addEventListener(MouseEvent.CLICK, btnEditorClickHandler);
			
			_volsSounds = new Vector.<VolumePlace>;
			_volsMusic = new Vector.<VolumePlace>;
			
			for (var i:uint = 0; i < 10; i++) {
				var place:VolumePlace = new VolumePlace(i + 1);
				var placeMusic:VolumePlace = new VolumePlace(i + 1);
				place.x = placeMusic.x = 600 + 20 * i;
				place.y = 390;
				placeMusic.y = 450;
				place.addEventListener(VolumePlace.VOLUME_CLICK, volumeSoundClickHandler);
				placeMusic.addEventListener(VolumePlace.VOLUME_CLICK, volumeMusicClickHandler);
				_ui.addChild(place);
				_ui.addChild(placeMusic);
				_volsSounds.push(place);
				_volsMusic.push(placeMusic);
			}
			
			updateVolume();
			updateButton();
			
			addChild(_ui);
			
			resize();
		}
		
		private function btnMusicClickHandler(e:MouseEvent):void 
		{
			if (Core.data.volumeMusic) Core.data.volumeMusic = 0;
			else Core.data.volumeMusic = 1;
			updateVolume();
			updateButton();
		}
		
		private function btnVolumeClickHandler(e:MouseEvent):void 
		{
			if (Core.data.volumeSound) Core.data.volumeSound = 0;
			else Core.data.volumeSound = 1;
			updateVolume();
			updateButton();
		}
		
		private function btnEditorClickHandler(e:MouseEvent):void {
			Core.ui.showPage(UIManager.EDITOR_PAGE_ID);
		}
		
		private function updateButton():void 
		{
			if (Core.data.volumeSound) _ui.labelVolume.alpha = 1;
			else _ui.labelVolume.alpha = 0.5;
			if (Core.data.volumeMusic) _ui.labelMusic.alpha = 1;
			else _ui.labelMusic.alpha = 0.5;
		}
		
		private function updateVolume():void 
		{
			var d:uint = Core.data.volumeSound * _volsSounds.length;
			for (var i:uint = 0; i < _volsSounds.length; i++) {
				if (i < d) _volsSounds[i].alpha = 1;
				else _volsSounds[i].alpha = 0.5;
			}
			
			d = Core.data.volumeMusic * _volsMusic.length;
			for (i = 0; i < _volsMusic.length; i++) {
				if (i < d) _volsMusic[i].alpha = 1;
				else _volsMusic[i].alpha = 0.5;
			}
		}
		
		private function volumeMusicClickHandler(e:Event):void 
		{
			var place:VolumePlace = e.target as VolumePlace;
			Core.data.volumeMusic = place.id / _volsMusic.length;
			updateVolume();
			updateButton();
		}
		
		private function volumeSoundClickHandler(e:Event):void 
		{
			var place:VolumePlace = e.target as VolumePlace;
			Core.data.volumeSound = place.id / _volsSounds.length;
			updateVolume();
			updateButton();
		}
		
		private function settigsClickHandler(e:MouseEvent):void 
		{
			
		}
		
		private function gameClickHandler(e:MouseEvent):void 
		{
			Core.ui.showPage(UIManager.GAME_PAGE_ID);
		}
		
		//public
		override public function hideAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			super.hideAnimation()
			doHideAnimation(_ui, sec);
		}

		override public function showAnimation(sec:Number = DEFAULT_ANIMATION_TIME):void {
			super.showAnimation()
			doShowAnimation(_ui, sec);
		}
		
		override public function resize():void {
			_ui.x = (stage.stageWidth - 1200) / 2;
			if (_ui.x < -270) _ui.x = -270;
			_ui.y = (stage.stageHeight - 768) / 2;
			if (_ui.y < -137) _ui.y = -137;
		}
	}

}