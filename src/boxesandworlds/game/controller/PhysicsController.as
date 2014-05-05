package boxesandworlds.game.controller 
{
	import flash.utils.getTimer;
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	/**
	 * ...
	 * @author Sah
	 */
	public class PhysicsController extends Controller
	{		
		private var _world:Space;
		private var _meType:CbType;
		private var _movableType:CbType;
		private var _collisionType:CbType;
		private var _buttonType:CbType;
		private var _previosTime:int;
		
		public function PhysicsController(game:Game) 
		{
			super(game);
		}
		
		public function get world():Space { return _world; }
		public function get movableType():CbType {return _movableType;}
		public function get collisionType():CbType {return _collisionType;}
		public function get meType():CbType {return _meType;}
		public function get buttonType():CbType {return _buttonType;}
		
		override public function init():void 
		{			
			var gravity:Vec2 = new Vec2(0.0, 600.0);
			_world = new Space(gravity);
			
			_movableType = new CbType;
			_collisionType = new CbType;
			_meType = new CbType;
			_buttonType = new CbType;
		}
		
		override public function step():void 
		{	
			var curTime:uint = getTimer();
            var deltaTime:Number = (curTime - _previosTime);
            if (deltaTime == 0) {
                return;
            }
			
			for (var i:int = 0; i < _world.liveBodies.length; i++) {
				var body:Body = _world.liveBodies.at(i);
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
		
	}

}