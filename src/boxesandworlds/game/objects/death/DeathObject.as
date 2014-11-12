package boxesandworlds.game.objects.death 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.world.World;
	/**
	 * ...
	 * @author Sah
	 */
	public class DeathObject extends GameObject
	{
		private var _view:DeathObjectView;
		private var _properties:DeathObjectData;
		
		public function DeathObject(game:Game) 
		{
			super(game);
		}
		
		public function get deathData():DeathObjectData {return _properties;}
		public function set deathData(value:DeathObjectData):void {_properties = value;}
		public function get deathView():DeathObjectView {return _view;}
		public function set deathView(value:DeathObjectView):void { _view = value; }
		
		override public function init(params:Object = null):void {
			data = new DeathObjectData(game);
			_properties = data as DeathObjectData;
			data.init(params);
			
			_view = new DeathObjectView(game, this);
			view = _view;
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
			body.cbTypes.add(game.physics.deathType);
		}		
	}

}
