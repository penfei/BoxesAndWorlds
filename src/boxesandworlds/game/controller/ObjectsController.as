package boxesandworlds.game.controller 
{
	import boxesandworlds.game.objects.door.Door;
	import boxesandworlds.game.objects.enters.edgeDoor.EdgeDoor;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.objects.enters.gate.Gate;
	import boxesandworlds.game.objects.GameObject;
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
		
		public function loadMe(data:Object):void {
			_me.loadLevel(data.player);
		}
		
		public function loadLevel(data:Object):void {
			if(data[game.data.levelPath] != null){
				for each(var worldData:Object in data[game.data.levelPath].worlds) {
					var world:World = getWorldById(worldData.id);
					world.loadLevel(worldData);
				}
			}
		}
		
		public function saveLevel(save:Object):void {
			save.player = _me.saveLevel();
			save.level = game.data.levelPath;
			var arr:Array = new Array();
			for each(var world:World in _worlds) {
				arr.push(world.saveLevel());
			}
			save[game.data.levelPath] = { worlds:arr};
		}
		
		public function getObjectById(id:uint):GameObject 
		{
			for each(var world:World in _worlds) {
				for each(var object:GameObject in world.objects) {
					if (object.data.id == id) return object;
				}
			}
			return null;
		}
	}

}