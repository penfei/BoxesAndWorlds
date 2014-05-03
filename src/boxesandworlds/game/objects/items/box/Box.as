package boxesandworlds.game.objects.items.box 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.ItemData;
	/**
	 * ...
	 * @author Sah
	 */
	public class Box extends Item
	{
		private var _view:BoxView;
		private var _properties:BoxData;
		
		public function Box(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object = null):void {
			data = new BoxData(game);
			itemData = data as ItemData; 
			_properties = data as BoxData;
			_properties.init(params);
			
			_view = new BoxView(game, this);
			itemView = _view;
			view = _view;
			
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
		}		
	}

}