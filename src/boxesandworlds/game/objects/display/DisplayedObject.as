package boxesandworlds.game.objects.display 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.world.World;
	/**
	 * ...
	 * @author Sah
	 */
	public class DisplayedObject extends GameObject
	{
		private var _view:DisplayedObjectView;
		private var _properties:DisplayedObjectData;
		
		public function DisplayedObject(game:Game) 
		{
			super(game);
		}
		
		public function get displayData():DisplayedObjectData {return _properties;}
		public function set displayData(value:DisplayedObjectData):void {_properties = value;}
		public function get displayView():DisplayedObjectView {return _view;}
		public function set displayView(value:DisplayedObjectView):void { _view = value; }
		
		override public function init(params:Object = null):void {
			data = new DisplayedObjectData(game);
			_properties = data as DisplayedObjectData;
			data.init(params);
			
			_view = new DisplayedObjectView(game, this);
			view = _view;
			super.init();
		}		
	}

}
