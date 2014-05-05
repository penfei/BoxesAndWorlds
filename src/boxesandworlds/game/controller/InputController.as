package boxesandworlds.game.controller 
{
	import boxesandworlds.game.utils.MathUtils;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Sah
	 */
	public class InputController extends Controller
	{				
		public function InputController(game:Game) 
		{
			super(game);
		}
		
		override public function init():void 
		{
			game.stage.addEventListener(KeyboardEvent.KEY_DOWN, keybordDownHandler);
			game.stage.addEventListener(KeyboardEvent.KEY_UP, keybordUpHandler);
			game.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			game.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightMouseDownHandler);
			game.stage.focus = game.stage;
		}
		
		override public function destroy():void {
			game.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keybordDownHandler);
			game.stage.removeEventListener(KeyboardEvent.KEY_UP, keybordUpHandler);
			game.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			game.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			game.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			game.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightMouseDownHandler);
			game.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, rightMouseUpHandler);
			game.objects.me.playerData.isMoveRight = false;
			game.objects.me.playerData.isMoveLeft = false;
			game.objects.me.playerData.isMoveDown = false;
			game.objects.me.playerData.isMoveUp = false;
		}
		
		private function rightMouseDownHandler(e:MouseEvent):void 
		{
			game.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightMouseDownHandler);
			game.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, rightMouseUpHandler);
		}
		
		private function rightMouseUpHandler(e:MouseEvent):void 
		{
			game.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, rightMouseUpHandler);
			game.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightMouseDownHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			game.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			game.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			game.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			game.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			game.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			game.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function keybordDownHandler(e:KeyboardEvent):void 
		{
			if (!game.data.isGameOver) {
				if (e.keyCode == Keyboard.R) game.objects.rotateWorld();
				if (e.keyCode == Keyboard.E) game.objects.me.itemAction();
				if (e.keyCode == Keyboard.S || e.keyCode == Keyboard.DOWN) game.objects.me.enterTeleport();
				if (e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT) game.objects.me.playerData.isMoveRight = true;
				if (e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT) game.objects.me.playerData.isMoveLeft = true;
				if (e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W) game.objects.me.playerData.isMoveUp = true;
			}
		}
		
		private function keybordUpHandler(e:KeyboardEvent):void 
		{
			if(!game.data.isGameOver){
				if (e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT) game.objects.me.playerData.isMoveRight = false;
				if (e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT) game.objects.me.playerData.isMoveLeft = false;
				if (e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W) {
					game.objects.me.playerData.isMoveUp = false;
					game.objects.me.playerData.isJump = true;
				}
			}
		}
		
	}

}