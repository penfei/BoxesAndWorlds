package boxesandworlds.game.controller 
{
	import boxesandworlds.game.objects.GameObject;
	/**
	 * ...
	 * @author Sah
	 */
	public class World extends Controller
	{
		private var _objects:Vector.<GameObject> = new Vector.<GameObject>;
		
		public function World(game:Game) 
		{
			super(game);
		}
			
		public function get objects():Vector.<GameObject> { return _objects; }
		
		override public function init():void 
		{
			_objects = new Vector.<GameObject>;
		}
		
		override public function step():void 
		{
			
		}
		
		override public function destroy():void 
		{
			
		}
	}

}