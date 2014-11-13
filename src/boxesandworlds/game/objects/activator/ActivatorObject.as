package boxesandworlds.game.objects.activator 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.world.World;
	/**
	 * ...
	 * @author Sah
	 */
	public class ActivatorObject extends GameObject
	{
		private var _view:ActivatorObjectView;
		private var _properties:ActivatorObjectData;
		
		public function ActivatorObject(game:Game) 
		{
			super(game);
		}
		
		public function get activatorData():ActivatorObjectData {return _properties;}
		public function set activatorData(value:ActivatorObjectData):void {_properties = value;}
		public function get activatorView():ActivatorObjectView {return _view;}
		public function set activatorView(value:ActivatorObjectView):void { _view = value; }
		
		override public function init(params:Object = null):void {
			data = new ActivatorObjectData(game);
			_properties = data as ActivatorObjectData;
			data.init(params);
			
			_view = new ActivatorObjectView(game, this);
			view = _view;
			super.init();
		}		
		
		public function activate():void 
		{
			if (_properties.callBack != null) {
				_properties.callBack(this);
			}
		}
	}

}
