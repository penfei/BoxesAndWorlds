package boxesandworlds.game.world 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.box.Box;
	import boxesandworlds.game.objects.items.teleportBox.TeleportBox;
	import boxesandworlds.game.objects.player.Player;
	import boxesandworlds.game.objects.worldstructrure.WorldStructure;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class World
	{
		private var _objects:Vector.<GameObject> = new Vector.<GameObject>;
		
		[Embed(source = "../../../../assets/TestLevel.png")]
		private var Structure:Class;
		
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
			
			_structure = new WorldStructure(_game);
			_structure.init( { physicsBitmapData:(new Structure()).bitmapData,  start:new Vec2(_data.axis.x - _data.width / 2, _data.axis.y - _data.height / 2) } );
			
			_objects.push(_structure);
			
			var teleports:Vector.<TeleportBox> = new Vector.<TeleportBox>();
			for (var i:uint = 0; i < 2; i++) {
				var box:TeleportBox = new TeleportBox(_game);
				box.init( { start:new Vec2(100 + i * 50, 100), teleportId: 2 - i, id: 1 + i });
				_objects.push(box);
				teleports.push(box);
			}
			
			for (i = 0; i < 3; i++) {
				var box2:Box = new Box(_game);
				box2.init( { start:new Vec2(300 + i * 50, 100) });
				_objects.push(box2);
			}
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
		
		public function addPlayerToWorld():void {
			_objects.push(_game.objects.me);
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