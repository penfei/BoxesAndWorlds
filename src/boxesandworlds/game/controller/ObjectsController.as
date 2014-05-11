package boxesandworlds.game.controller 
{
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.objects.enters.gate.Gate;
	import boxesandworlds.game.objects.items.box.Box;
	import boxesandworlds.game.objects.items.teleportBox.TeleportBox;
	import boxesandworlds.game.objects.items.worldBox.WorldBox;
	import boxesandworlds.game.objects.player.Player;
	import boxesandworlds.game.objects.worldstructrure.WorldStructure;
	import boxesandworlds.game.world.World;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author ...
	 */
	public class ObjectsController extends Controller
	{
		[Embed(source = "../../../../assets/TestLevel.png")]
		private var Structure:Class;
		[Embed(source = "../../../../assets/TestLevel2.png")]
		private var Structure2:Class;
		
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
			_me.init( { start:new Vec2(450, 200) } );
			
			_worlds = new Vector.<World>;
			var world1:World = new World(game);
			world1.init({id:1, axis:new Vec2(400, 400)});
			_worlds.push(world1);
			
			var world2:World = new World(game);
			world2.init({id:2, axis:new Vec2(1400, 400)});
			_worlds.push(world2);
			
			var structure:WorldStructure = new WorldStructure(game);
			structure.init( { physicsBitmapData:(new Structure()).bitmapData,  start:new Vec2(world1.data.axis.x - world1.data.width / 2, world1.data.axis.y - world1.data.height / 2) } );
			world1.addStructureToWorld(structure);
			
			structure = new WorldStructure(game);
			structure.init( { physicsBitmapData:(new Structure2()).bitmapData,  start:new Vec2(world2.data.axis.x - world2.data.width / 2, world2.data.axis.y - world2.data.height / 2) } );
			world2.addStructureToWorld(structure);
			
			var box:TeleportBox = new TeleportBox(game);
			box.init( { start:new Vec2(100, 100), teleportId: 2, id: 1 } );
			world1.addGameObject(box);
			
			box = new TeleportBox(game);
			box.init( { start:new Vec2(1200, 100), teleportId: 1, id: 2 } );
			world2.addGameObject(box);
			
			var worldBox:WorldBox = new WorldBox(game);
			worldBox.init( { start:new Vec2(600, 100), childWorldId: 2 } );
			world1.addGameObject(worldBox);
			//gate после worldbox
			var gate:Gate = new Gate(game);
			gate.init( { start:new Vec2(1030, 635), width:60, height:150} );
			world2.addGameObject(gate);
			
			gate = new Gate(game);
			gate.init( { start:new Vec2(1335, 27), width:220, height:55, edge:EnterData.TOP} );
			world2.addGameObject(gate);
			
			for (var i:uint = 0; i < 3; i++) {
				var box2:Box = new Box(game);
				box2.init( { start:new Vec2(300+ i * 50, 100 ) });
				world1.addGameObject(box2);
			}
			
			box2 = new Box(game);
			box2.init( { start:new Vec2(600, 50)});
			world1.addGameObject(box2);
			
			world1.addGameObject(_me);
			
			for each(var world:World in _worlds) {
				world.postInit();
			}
			
			//world1.rotate(90);
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