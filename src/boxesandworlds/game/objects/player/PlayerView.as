package boxesandworlds.game.objects.player 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectView;
	import boxesandworlds.game.utils.MathUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import symbols.game.HeroStayUI;
	import symbols.game.HeroWalkUI;
	import symbols.game.HeroJumpUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class PlayerView extends GameObjectView
	{
		private var _ui:Sprite
		private var _player:Player;
		private var _uiStay:HeroStayUI;
		private var _uiWalk:HeroWalkUI;
		private var _uiJump:HeroWalkUI;
		
		public function PlayerView(game:Game, player:Player) 
		{
			_player = player;
			super(game, player)
		}
		
		override public function init():void {
			_ui = new Sprite
			_uiStay = new HeroStayUI;
			_uiWalk = new HeroWalkUI;
			_ui.addChild(_uiStay);
			addChild(_ui);
		}
		
		public function step():void {
			
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
			}
			_ui.rotationY = -180;
		}
		
		public function showRight():void {
			if (_player.playerData.isOnEarth) {
				game.sound.walking();
				visibleState(_uiWalk);
				unVisibleState(_uiStay);
			}
			_ui.rotationY = 0;
		}
		
		public function showStay():void {
			if (_player.playerData.isOnEarth) {
				visibleState(_uiStay);
				unVisibleState(_uiWalk);
			}
		}
		
		public function rotateY(value:Number):void {
			_ui.rotationY = value;
		}
		
		private function visibleState(view:MovieClip):void {
			if(!view.parent){
				_ui.addChild(view);
				var mc:MovieClip
				for ( var i:uint = 0; i < _ui.numChildren; i++ ) {
					if (_ui.getChildAt(i) is MovieClip) {
						mc = _ui.getChildAt(i) as MovieClip;
						if (mc.totalFrames > 1) mc.gotoAndPlay(1);
					}
				}
			}
		}
		
		private function unVisibleState(view:MovieClip):void  {
			if(view.parent){
				_ui.removeChild(view);
				var mc:MovieClip
				for ( var i:uint = 0; i < _ui.numChildren; i++ ) {
					if (_ui.getChildAt(i) is MovieClip) {
						mc = _ui.getChildAt(i) as MovieClip;
						if (mc.totalFrames > 1) mc.stop();
					}
				}
			}
		}
	}

}