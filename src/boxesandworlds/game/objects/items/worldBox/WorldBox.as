package boxesandworlds.game.objects.items.worldBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.ItemData;
	import boxesandworlds.game.world.World;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldBox extends Item
	{
		private var _view:WorldBoxView;
		private var _properties:WorldBoxData;
		
		private var _childWorld:World;
		
		public function WorldBox(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object = null):void {
			data = new WorldBoxData(game);
			itemData = data as ItemData; 
			_properties = data as WorldBoxData;
			_properties.init(params);
			
			_view = new WorldBoxView(game, this);
			itemView = _view;
			view = _view;
			
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
		}
		
		override public function postInit():void 
		{
			super.postInit();
			
			if (_properties.childWorldId != 0) {
				for each(var world:World in game.objects.worlds) {
					if (world.data.id == _properties.childWorldId) {
						_childWorld = world;
					}
				}
			}
		}
		
		override public function step():void 
		{
			super.step();
			_childWorld.rotate(body.rotation);
		}
	}

}