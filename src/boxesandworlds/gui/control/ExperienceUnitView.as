package boxesandworlds.gui.control 
{
	import boxesandworlds.data.ExperienceUnit;
	import flash.display.Sprite;
	import flash.events.Event;
	import symbols.view.ExperienceUnitUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class ExperienceUnitView extends Sprite
	{
		private var _id:uint;
		private var _unit:ExperienceUnit;
		private var _ui:ExperienceUnitUI;
		private var _places:Vector.<VolumePlace>
		
		public function ExperienceUnitView(id:uint, unit:ExperienceUnit) 
		{
			_unit = unit;
			_id = id;
			_ui = new ExperienceUnitUI;
			_ui.label.text = _unit.name;
			
			_places = new Vector.<VolumePlace>;
			for (var i:uint = 0; i < _unit.maxStep; i++) {
				var place:VolumePlace = new VolumePlace(i);
				place.x = 300 + i * 20;
				place.addEventListener(VolumePlace.VOLUME_CLICK, placeClickHandler);
				_ui.addChild(place);
				_places.push(place);
			}
			addChild(_ui)
			
			updateValues()
		}
		
		private function updateValues():void 
		{
			for (var i:uint = 0; i < _unit.maxStep; i++) {
				if (i < _unit.step) _places[i].alpha = 1;
				else _places[i].alpha = 0.5;
			}
			_ui.value.text = _unit.value.toString();
			_ui.price.text = _unit.price.toString();
		}
		
		private function placeClickHandler(e:Event):void 
		{
			var place:VolumePlace = e.target as VolumePlace;
			_unit.step = place.id + 1;
			updateValues();
		}
		
	}

}