package boxesandworlds.game.controller 
{
	import boxesandworlds.game.objects.door.Door;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.button.Button;
	import boxesandworlds.game.objects.items.key.Key;
	import boxesandworlds.game.world.World;
	import flash.utils.getTimer;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	/**
	 * ...
	 * @author Sah
	 */
	public class PhysicsController extends Controller
	{		
		private var _world:Space;
		private var _meType:CbType;
		private var _collisionType:CbType;
		private var _doorType:CbType;
		private var _keyType:CbType;
		private var _buttonType:CbType;
		private var _previosTime:int;
		
		public function PhysicsController(game:Game) 
		{
			super(game);
		}
		
		public function get world():Space { return _world; }
		public function get collisionType():CbType {return _collisionType;}
		public function get meType():CbType {return _meType;}
		public function get buttonType():CbType { return _buttonType; }
		public function get doorType():CbType {return _doorType;}
		public function get keyType():CbType {return _keyType;}
		
		override public function init():void 
		{			
			var gravity:Vec2 = new Vec2(0.0, 600.0);
			_world = new Space(gravity);
			
			_collisionType = new CbType;
			_meType = new CbType;
			_buttonType = new CbType;
			_keyType = new CbType;
			_doorType = new CbType;
			
			game.physics.world.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, _doorType, _keyType, doorKeyContactHandler));
			game.physics.world.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, _buttonType, _collisionType, buttonContactStartHandler));
			game.physics.world.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, _buttonType, _collisionType, buttonContactEndHandler));
		}
		
		override public function step():void 
		{	
			var curTime:uint = getTimer();
            var deltaTime:Number = (curTime - _previosTime);
            if (deltaTime == 0) {
                return;
            }
			
			for (var i:int = 0; i < _world.bodies.length; i++) {
				var body:Body = _world.bodies.at(i);
				if (body.userData.obj) {
					var graphic:* = body.userData.obj.view;
					if (graphic) {
						graphic.x = body.position.x;
						graphic.y = body.position.y;
						graphic.rotation = body.rotation * 180 / Math.PI;
					}
				}
			}			

            var stepSize:Number = (1000 / game.stage.frameRate);
            stepSize = 1000/60;
            var steps:uint = Math.round(deltaTime / stepSize);

            var delta:Number = Math.round(deltaTime - (steps * stepSize));
            _previosTime = (curTime - delta);
            if (steps > 4) {
                steps = 4;
            }
            deltaTime = steps * stepSize;

            while (steps-- > 0) {
                _world.step(stepSize * 0.001);
            }
		}
		
		override public function destroy():void 
		{
			_world.clear();
		}
		
		private function doorKeyContactHandler(e:InteractionCallback):void 
		{
			var door:Door = e.int1.userData.obj as Door;
			var key:Key = e.int2.userData.obj as Key;
			if (key.keyData.openedId == door.data.id) {
				door.open();
				if(game.objects.me.hasItem && game.objects.me.item == key) game.objects.me.resetItem();
				key.destroy();
			}
		}
		
		private function buttonContactStartHandler(e:InteractionCallback):void 
		{
			var button:Button = e.int1.userData.obj as Button;
			button.openDoor();
		}
		
		private function buttonContactEndHandler(e:InteractionCallback):void 
		{
			var button:Button = e.int1.userData.obj as Button;
			button.closeDoor();
		}
	}

}