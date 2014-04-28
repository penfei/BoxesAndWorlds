package boxesandworlds.game.controller 
{
	import boxesandworlds.game.objects.items.Item;
	/**
	 * ...
	 * @author Sah
	 */
	public class World extends Controller
	{
		private var _items:Vector.<Item> = new Vector.<Item>;
		
		public function World(game:Game) 
		{
			super(game);
		}
			
		public function get items():Vector.<Item> { return _items; }
		
		override public function init():void 
		{
			_items = new Vector.<Item>;
		}
		
		override public function step():void 
		{
			
		}
		
		override public function destroy():void 
		{
			
		}
	}

}