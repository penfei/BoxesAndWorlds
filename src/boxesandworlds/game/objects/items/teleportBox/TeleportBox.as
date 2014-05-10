package boxesandworlds.game.objects.items.teleportBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.ItemData;
	import boxesandworlds.game.world.World;
	/**
	 * ...
	 * @author Sah
	 */
	public class TeleportBox extends Item
	{
		private var _view:TeleportBoxView;
		private var _properties:TeleportBoxData;
		
		public function TeleportBox(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object = null):void {
			data = new TeleportBoxData(game);
			itemData = data as ItemData; 
			_properties = data as TeleportBoxData;
			_properties.init(params);
			
			_view = new TeleportBoxView(game, this);
			itemView = _view;
			view = _view;
			
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
			//body.shapes.at(0).filter.collisionMask = ~0x0100;
		}
	}

}