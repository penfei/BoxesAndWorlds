package boxesandworlds.game.world 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.player.Player;
	import boxesandworlds.game.objects.worldstructrure.WorldStructure;
	/**
	 * ...
	 * @author Sah
	 */
	public class World
	{
		private var _objects:Vector.<GameObject> = new Vector.<GameObject>;
		
		private var _structure:WorldStructure;
		private var _data:WorldData;
		private var _game:Game;
		
		public function World(game:Game) 
		{
			_game = game;
		}
			
		public function get objects():Vector.<GameObject> { return _objects; }
		public function get data():WorldData {return _data;}
		
		public function init(params:Object):void 
		{
			_data = new WorldData(_game);
			_data.init(params);
			_objects = new Vector.<GameObject>;
		}
		
		public function createConnections():void 
		{
			for each(var obj:GameObject in _objects) {
				obj.findTeleportTarget();
			}
		}
		
		public function step():void 
		{
			
		}
		
		public function destroy():void 
		{
			
		}
		
		public function addStructureToWorld(str:WorldStructure):void {
			_structure = str;
			addGameObject(_structure);
		}
		
		public function addGameObject(obj:GameObject):void {
			obj.world = this;
			_objects.push(obj);
		}
		
		public function removeGameObject(obj:GameObject):void 
		{
			for (var i:uint = 0; i < _objects.length; i++) {
				if (obj == _objects[i]) {
					obj.world = null;
					_objects.splice(i, 1);
				}
			}
		}
		
		public function rotate(angle:Number):void 
		{
			var a:Number = 2 * Math.PI * (angle / 360);
			for each(var obj:GameObject in _objects) {
				if(obj.body.isStatic()) obj.body.space = null;
				obj.body.rotate(_data.axis, a);
				if (obj is Player) {
					obj.body.rotation = 0;
				}
				if(obj.body.isStatic()) obj.body.space = _game.physics.world;
			}
		}
		
		
	}

}