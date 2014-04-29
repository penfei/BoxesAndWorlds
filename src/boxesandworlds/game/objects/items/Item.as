package boxesandworlds.game.objects.items 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	/**
	 * ...
	 * @author Sah
	 */
	public class Item extends GameObject
	{
		private var _view:ItemView;
		private var _properties:ItemData;
		
		public function Item(game:Game) 
		{
			super(game);
		}
		
		public function get itemView():ItemView {return _view;}
		public function set itemView(value:ItemView):void {_view = value;}
		public function get itemData():ItemData {return _properties;}
		public function set itemData(value:ItemData):void {_properties = value;}
		
	}

}