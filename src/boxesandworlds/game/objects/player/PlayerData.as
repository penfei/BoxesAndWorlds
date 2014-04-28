package boxesandworlds.game.objects.player 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class PlayerData extends GameObjectData
	{
		private var _speed:Number;
		private var _isMoveRight:Boolean;
		private var _isMoveLeft:Boolean;
		private var _isMoveDown:Boolean;
		private var _isMoveUp:Boolean;
		private var _isJump:Boolean;
		private var _jumpPower:Number;
		private var _isOnEarth:Boolean;
		
		public function PlayerData(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			type = "Player";
			width = 66;
			height = 120;
			bodyType = BodyType.DYNAMIC;
			bodyShapeType = GameObjectData.BOX_SHAPE;
			container = game.gui.container;
			density = 12;
			dynamicFriction = 0;
			staticFriction = 0;
			elasticity = 0.0;
			offsetX = 5;
			offsetY = 5;
			_speed = 300;
			_jumpPower = -35000;
			_isMoveLeft = false;
			_isMoveDown = false;
			_isMoveUp = false;
			_isJump = true;
			_isOnEarth = false;
		}
		
		public function get isMoveRight():Boolean {return _isMoveRight;}
		public function set isMoveRight(value:Boolean):void {_isMoveRight = value;}
		public function get isMoveLeft():Boolean {return _isMoveLeft;}
		public function set isMoveLeft(value:Boolean):void {_isMoveLeft = value;}
		public function get isMoveDown():Boolean {return _isMoveDown;}
		public function set isMoveDown(value:Boolean):void {_isMoveDown = value;}
		public function get isMoveUp():Boolean {return _isMoveUp;}
		public function set isMoveUp(value:Boolean):void {_isMoveUp = value;}
		public function get speed():Number {return _speed;}
		public function set speed(value:Number):void {_speed = value;}
		public function get isJump():Boolean {return _isJump;}
		public function set isJump(value:Boolean):void {_isJump = value;}
		public function get jumpPower():Number {return _jumpPower;}
		public function set jumpPower(value:Number):void {_jumpPower = value;}
		public function get isOnEarth():Boolean {return _isOnEarth;}
		public function set isOnEarth(value:Boolean):void {_isOnEarth = value;}
		
		public function get anyButton():Boolean {
			if (isMoveRight || isMoveLeft || isMoveUp || isMoveDown) return true;
			else return false;
		}
		
	}

}