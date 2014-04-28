package boxesandworlds.game.controller 
{
	import boxesandworlds.game.controller.World;
	import boxesandworlds.game.objects.player.Player;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
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
			_me.init( { start:new Vec2(50, 200) } );
			
			_worlds = new Vector.<World>;
			
			var floor:Body = new Body(BodyType.STATIC);
            floor.shapes.add(new Polygon(Polygon.rect(10, 600, 780, 10)));
            floor.space = game.physics.world;
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
	}

}