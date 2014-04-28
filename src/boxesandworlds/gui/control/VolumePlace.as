package boxesandworlds.gui.control 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import symbols.view.VolumePlaceUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class VolumePlace extends Sprite
	{
		static public const VOLUME_CLICK:String = "volumeClick";
		
		private var _ui:VolumePlaceUI;
		private var _id:uint;
		
		public function VolumePlace(id:uint) 
		{
			_id = id;
			_ui = new VolumePlaceUI;
			_ui.buttonMode = true;
			_ui.addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(_ui);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			dispatchEvent(new Event(VOLUME_CLICK))
		}
		
		public function get id():uint {return _id;}
		
	}

}