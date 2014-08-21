package boxesandworlds.game.controller 
{
	import boxesandworlds.game.objects.door.Door;
	import boxesandworlds.game.objects.enters.edgeDoor.EdgeDoor;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.objects.enters.gate.Gate;
	import boxesandworlds.game.objects.items.box.Box;
	import boxesandworlds.game.objects.items.button.Button;
	import boxesandworlds.game.objects.items.key.Key;
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
		[Embed(source = "../../../../assets/TestLevel3.png")]
		private var Structure3:Class;
		
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
			_worlds = new Vector.<World>;
			return;
			
			//_me.init( { start:game.level.data.startHeroPostion } );
			_me.init( { start:new Vec2(420, 200) } );
			
			var world1:World = new World(game);
			world1.init({id:1, axis:new Vec2(400, 400)});
			_worlds.push(world1);
			
			var world2:World = new World(game);
			world2.init({id:2, axis:new Vec2(1400, 400)});
			_worlds.push(world2);
			
			var world3:World = new World(game);
			world3.init({id:3, axis:new Vec2(2400, 400)});
			_worlds.push(world3);
			
			var world4:World = new World(game);
			world4.init({id:4, axis:new Vec2(3400, 400)});
			_worlds.push(world4);
			
			var structure:WorldStructure = new WorldStructure(game);
			structure.init( { physicsBitmapData:(new Structure()).bitmapData,  start:new Vec2(world1.data.axis.x - world1.data.width / 2, world1.data.axis.y - world1.data.height / 2) } );
			world1.addStructureToWorld(structure);
			
			structure = new WorldStructure(game);
			structure.init( { physicsBitmapData:(new Structure2()).bitmapData,  start:new Vec2(world2.data.axis.x - world2.data.width / 2, world2.data.axis.y - world2.data.height / 2) } );
			world2.addStructureToWorld(structure);
			
			structure = new WorldStructure(game);
			structure.init( { physicsBitmapData:(new Structure3()).bitmapData,  start:new Vec2(world3.data.axis.x - world3.data.width / 2, world3.data.axis.y - world3.data.height / 2) } );
			world3.addStructureToWorld(structure);
			
			structure = new WorldStructure(game);
			structure.init( { physicsBitmapData:(new Structure()).bitmapData,  start:new Vec2(world4.data.axis.x - world4.data.width / 2, world4.data.axis.y - world4.data.height / 2) } );
			world4.addStructureToWorld(structure);
			
			var box:TeleportBox = new TeleportBox(game);
			box.init( { start:new Vec2(100, 100), teleportId: 2, id: 1 } );
			world1.addGameObject(box);
			
			box = new TeleportBox(game);
			box.init( { start:new Vec2(2300, 100), teleportId: 1, id: 2 } );
			world3.addGameObject(box);
			
			var worldBox:WorldBox = new WorldBox(game);
			worldBox.init( { start:new Vec2(550, 100), childWorldId: 2 } );
			world1.addGameObject(worldBox);
			
			worldBox = new WorldBox(game);
			worldBox.init( { start:new Vec2(500, 100), childWorldId: 3 } );
			world1.addGameObject(worldBox);
			
			var door:Door = new Door(game);
			door.init( { start:new Vec2(700, 300), id:3 } );
			world1.addGameObject(door);
			
			var key:Key = new Key(game);
			key.init( { start:new Vec2(400, 300), openedId:3 } );
			world1.addGameObject(key);
			
			var button:Button = new Button(game);
			button.init( { start:new Vec2(400, 720), openedId:3 } );
			world1.addGameObject(button);
			
			//worldBox = new WorldBox(game);
			//worldBox.init( { start:new Vec2(550, 100), childWorldId: 4 } );
			//world1.addGameObject(worldBox);
			//gate после worldbox
			var gate:Gate = new Gate(game);
			gate.init( { start:new Vec2(1030, 635), width:60, height:150} );
			world2.addGameObject(gate);
			
			//gate = new Gate(game);
			//gate.init( { start:new Vec2(1335, 27), width:220, height:55, edge:EnterData.TOP} );
			//world2.addGameObject(gate);
			
			var edgeDoor:EdgeDoor = new EdgeDoor(game);
			edgeDoor.init( { start:new Vec2(1335, 27), width:220, height:55, edge:EnterData.TOP} );
			world2.addGameObject(edgeDoor);
			
			gate = new Gate(game);
			gate.init( { start:new Vec2(2770, 663), width:60, height:155, edge:EnterData.RIGHT} );
			world3.addGameObject(gate);
			
			for (var i:uint = 0; i < 3; i++) {
				var box2:Box = new Box(game);
				box2.init( { start:new Vec2(200+ i * 50, 100 ) });
				world1.addGameObject(box2);
			}
			
			box2 = new Box(game);
			box2.init( { start:new Vec2(550, 150)});
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
		
		public function getWorldById(id:uint):World 
		{
			for each(var world:World in _worlds) {
				if (world.data.id == id) return world;
			}
			return null;
		}
		
		public function loadLevel(data:Object):void {
			
		}
		
		public function saveLevel(save:Object):void {
			save.player = {level: game.data.xmlLevelPath, world:_me.world.data.id, posX:_me.body.position.x, posY:_me.body.position.x, rotation:_me.body.rotation};
			var arr:Array = new Array();
			for each(var world:World in _worlds) {
				arr.push(world.saveLevel());
			}
			save[game.data.xmlLevelPath] = { worlds:arr};
		}
	}

}