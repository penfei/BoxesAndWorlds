package boxesandworlds.game.objects.player 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	import boxesandworlds.game.utils.MathUtils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import symbols.hero.StayUI;
	import symbols.hero.RunUI;
	import symbols.hero.JumpUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class PlayerView extends GameObjectView
	{
		private var _ui:Sprite
		private var _player:Player;
		private var _uiStay:StayUI;
		private var _uiWalk:RunUI;
		private var _uiJump:JumpUI;
		
		public function PlayerView(game:Game, player:Player) 
		{
			_player = player;
			super(game, player)
		}
		
		override public function init():void {
			_ui = new Sprite
			_uiStay = new StayUI;
			_uiWalk = new RunUI;
			_uiJump = new JumpUI;
			_ui.addChild(_uiStay);
			
			obj.data.views.push(_ui);
			obj.data.containerIds[0] = 0;
			super.init();
		}
		
		override public function step():void {
			
		}
		
		public function get isRight():Boolean {
			if (!_ui.rotationY) return true;
			return false;
		}
		
		public function showLeft():void {
			if (_player.playerData.isOnEarth) {
				game.sound.walking();
				visibleState(_uiWalk);
				unVisibleState(_uiStay);
				unVisibleState(_uiJump);
			}
			_ui.rotationY = -180;
		}
		
		public function showRight():void {
			if (_player.playerData.isOnEarth) {
				game.sound.walking();
				visibleState(_uiWalk);
				unVisibleState(_uiStay);
				unVisibleState(_uiJump);
			}
			_ui.rotationY = 0;
		}
		
		public function showStay():void {
			if (_player.playerData.isOnEarth) {
				visibleState(_uiStay);
				unVisibleState(_uiWalk);
				unVisibleState(_uiJump);
			}
		}
		
		public function showJump():void {
			unVisibleState(_uiWalk);
			unVisibleState(_uiStay);
			visibleState(_uiJump);
			
			var vel:Number = _player.body.velocity.y
			var frame:int = (_uiJump.totalFrames + 1) / 2 + (vel * (_uiJump.totalFrames + 1) * 0.0016);
			if (vel < 0) {
				frame = frame + 0.5;
				if (frame < 1) frame = 1;
				if (frame > (_uiJump.totalFrames + 1) / 2) frame = (_uiJump.totalFrames + 1) / 2;
			} else {
				if (frame > _uiJump.totalFrames) frame = _uiJump.totalFrames;
			}
			_uiJump.gotoAndStop(frame);
		}
		
		public function rotateY(value:Number):void {
			_ui.rotationY = value;
		}
		
		private function visibleState(view:MovieClip):void {
			if (!view.parent) {
				_ui.addChild(view);
				view.gotoAndPlay(1);
				//var mc:MovieClip
				//for ( var i:uint = 0; i < _ui.numChildren; i++ ) {
					//if (_ui.getChildAt(i) is MovieClip) {
						//mc = _ui.getChildAt(i) as MovieClip;
						//if (mc.totalFrames > 1) mc.gotoAndPlay(1);
					//}
				//}
			}
		}
		
		private function unVisibleState(view:MovieClip):void  {
			if(view.parent){
				_ui.removeChild(view);
				//var mc:MovieClip
				//for ( var i:uint = 0; i < _ui.numChildren; i++ ) {
					//if (_ui.getChildAt(i) is MovieClip) {
						//mc = _ui.getChildAt(i) as MovieClip;
						//if (mc.totalFrames > 1) mc.stop();
					//}
				//}
			}
		}
	}

}