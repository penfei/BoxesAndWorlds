package boxesandworlds.game.objects.items.key 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.ItemData;
	/**
	 * ...
	 * @author Sah
	 */
	public class Key extends Item
	{
		private var _view:KeyView;
		private var _properties:KeyData;
		
		public function Key(game:Game) 
		{
			super(game);
		}
		
		public function get keyView():KeyView {return _view;}
		public function set keyView(value:KeyView):void {_view = value;}
		public function get keyData():KeyData {return _properties;}
		public function set keyData(value:KeyData):void {_properties = value;}
		
		override public function init(params:Object = null):void {
			data = new KeyData(game);
			itemData = data as ItemData; 
			_properties = data as KeyData;
			_properties.init(params);
			
			_view = new KeyView(game, this);
			itemView = _view;
			view = _view;
			
			super.init();
			
			body.shapes.at(0).filter.collisionGroup = 0x1000;
			body.cbTypes.add(game.physics.keyType);
		}		
	}

}