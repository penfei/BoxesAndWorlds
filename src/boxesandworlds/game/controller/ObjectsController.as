package boxesandworlds.game.controller 
{
	import boxesandworlds.game.world.World;
	import boxesandworlds.game.objects.player.Player;
	import boxesandworlds.game.world.World;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author ...
	 */
	public class ObjectsController extends Controller
	{
		private var _me:Player;
		private var _worlds:Vector.<World>;
		
		public function ObjectsController(game:Game) 
		{
			super(game);
		}
		
		public function get me():Player {return _me;}
		public function get worlds():Vector.<World> {return _worlds;}
		
		override public function init():void 
		{
			_me = new Player(game);
			//_me.init( { start:game.level.data.startHeroPostion } );
			_me.init( { start:new Vec2(650, 200) } );
			
			_worlds = new Vector.<World>;
			var world1:World = new World(game);
			world1.init({axis:new Vec2(400, 400)});
			_worlds.push(world1);
			
			world1.addPlayerToWorld();
			
			for each(var world:World in _worlds) {
				world.createConnections();
			}
		}
		
		override public function destroy():void {
			_me.destroy();
			_me = null;
			
			for each(var world:World in _worlds) {
				world.destroy();
				world = null;
			}
		}
		
		override public function step():void {
			_me.step();
			for each(var world:World in _worlds) {
				world.step();
			}
		}	
		
		public function resize():void 
		{
			
		}
		
		public function rotateWorld():void 
		{
			_worlds[0].rotate(90);
		}
	}

}