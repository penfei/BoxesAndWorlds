package boxesandworlds.game.world 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.worldBox.WorldBox;
	import boxesandworlds.game.objects.player.Player;
	import boxesandworlds.game.objects.worldstructrure.WorldStructure;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
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
		private var _worldBox:WorldBox;
		private var _worldBody:Body;
		private var _connectWorldsHash:Object;
		
		public function World(game:Game) 
		{
			_game = game;
		}
			
		public function get objects():Vector.<GameObject> { return _objects; }
		public function get data():WorldData {return _data;}
		public function get worldBox():WorldBox {return _worldBox;}
		public function set worldBox(value:WorldBox):void {_worldBox = value;}
		public function get worldBody():Body {return _worldBody;}
		public function get structure():WorldStructure { return _structure; }
		public function set structure(value:WorldStructure):void {_structure = value;}
		public function get visible():Boolean {
			if (_game.objects.me.world == null) return false;
			return data.id == _game.objects.me.world.data.id;
		}
		
		public function init(params:Object):void 
		{
			_data = new WorldData(_game);
			_data.init(params);
			_objects = new Vector.<GameObject>;
			
			_connectWorldsHash = { };
		}
		
		public function postInit():void 
		{
			for each(var obj:GameObject in _objects) {
				obj.postInit();
			}
		}
		
		public function step():void 
		{
			for each(var obj:GameObject in _objects) {
				obj.step();
			}
		}
		
		public function destroy():void 
		{
			
		}
		
		public function loadLevel(save:Object):void {
			for each(var objectData:Object in save.objects) {
				var obj:GameObject = _game.objects.getObjectById(objectData.id);
				obj.loadLevel(objectData);
			}
		}
		
		public function saveLevel():Object {
			var obj:Object = { id:data.id };
			obj.objects = new Array();
			for each(var object:GameObject in _objects) {
				if (!(object is Player)) obj.objects.push(object.saveLevel());
			}
			return obj;
		}
		
		public function rotate(angle:Number):void 
		{
			var a:Number = angle - _data.rotation;
			_worldBody.space = null;
			_worldBody.rotate(_data.axis, a);
			_worldBody.space = _game.physics.world;
			for each(var obj:GameObject in _objects) {
				if(obj.body.isStatic()) obj.body.space = null;
				obj.body.rotate(_data.axis, a);
				if (obj is Player) {
					obj.body.rotation = 0;
				}
				if(obj.body.isStatic()) obj.body.space = _game.physics.world;
			}
			_data.rotation = angle;
		}
		
		public function getOjbjectsByType(objClass:Class):Array
		{
			var arr:Array = new Array();
			for each(var obj:GameObject in _objects) {
				if (obj is objClass) arr.push(obj);
			}
			return arr;
		}
		
		public function getConnectedWorldByEdge(edge:String):World
		{
			return _connectWorldsHash[edge];
		}
		
		public function getEnterByEdge(edge:String):Enter
		{
			var enter:Enter;
			for each(var obj:GameObject in _objects) {
				enter = obj as Enter;
				if (enter != null && enter.enterData.isOpen && enter.enterData.edge == edge) return enter;
			}
			return null;
		}
		
		public function getEdgeByWorld(world:World):String 
		{
			for (var key:String in _connectWorldsHash) {
				if (_connectWorldsHash[key] == world) return key;
			}
			return null;
		}
		
		public function connectWorldToEdge(world:World, connectedEdge:String):void 
		{
			_connectWorldsHash[connectedEdge] = world;
		}
		
		public function clearConnectedWorlds():void 
		{
			for each(var w:World in _connectWorldsHash) {
				w.disconnectWorld(this);
				disconnectWorld(w);
			}
		}
		
		public function getObjectById(id:uint):GameObject 
		{
			for each(var object:GameObject in _objects) {
				if (object.data.id == id) return object;
			}
			return null;
		}
		
		public function removeObjectById(id:uint):GameObject 
		{
			for (var i:uint = 0; i < _objects.length; i++) {
				if (_objects[i].data.id == id) {
					var o:GameObject = _objects[i];
					_objects.splice(i, 1);
					return o;
				}
			}
			return null;
		}
		
		public function disconnectWorld(world:World):void 
		{
			for (var key:String in _connectWorldsHash) {
				if (_connectWorldsHash[key] == world) {
					delete _connectWorldsHash[key];
					return;
				}
			}
		}
		
		public function initWorldBody():void 
		{
			_worldBody = new Body(BodyType.STATIC, Vec2.get(_structure.body.position.x + data.width / 2, _structure.body.position.y + data.height / 2));
			var shape:Shape = new Polygon(Polygon.box(data.width, data.height));
			_worldBody.shapes.add(shape);
			_worldBody.space = _game.physics.world;
			
			for (var i:uint = 0; i < _worldBody.shapes.length; i++) {
				_worldBody.shapes.at(i).sensorEnabled = true;
			}
		}
	}

}