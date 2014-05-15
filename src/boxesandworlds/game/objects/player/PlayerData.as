package boxesandworlds.game.objects.player 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
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
		private var _itemAreaIndentX:Number;
		private var _itemAreaIndentY:Number;
		private var _isRight:Boolean;
		
		public function PlayerData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "type", "Player", Attribute.STRING);
			Attribute.pushAttribute(arr, "bodyShapeType", GameObjectData.BOX_SHAPE, Attribute.STRING);
			Attribute.pushAttribute(arr, "bodyType", BodyType.DYNAMIC, Attribute.STRING);
			Attribute.pushAttribute(arr, "width", 66, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "height", 120, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "density", 12, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "elasticity", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "dynamicFriction", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "staticFriction", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "offsetX", 1, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "offsetY", 5, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "speed", 300, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "jumpPower", -35000, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "isMoveLeft", false, Attribute.BOOL);
			Attribute.pushAttribute(arr, "isMoveDown", false, Attribute.BOOL);
			Attribute.pushAttribute(arr, "isMoveUp", false, Attribute.BOOL);
			Attribute.pushAttribute(arr, "isJump", true, Attribute.BOOL);
			Attribute.pushAttribute(arr, "isOnEarth", false, Attribute.BOOL);
			Attribute.pushAttribute(arr, "isRight", true, Attribute.BOOL);
			Attribute.pushAttribute(arr, "itemAreaIndentX", 30, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "itemAreaIndentY", 30, Attribute.NUMBER);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
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
		public function get itemAreaIndentX():Number {return _itemAreaIndentX;}
		public function set itemAreaIndentX(value:Number):void {_itemAreaIndentX = value;}
		public function get itemAreaIndentY():Number {return _itemAreaIndentY;}
		public function set itemAreaIndentY(value:Number):void { _itemAreaIndentY = value; }
		
		public function get anyButton():Boolean {
			if (isMoveRight || isMoveLeft || isMoveUp || isMoveDown) return true;
			else return false;
		}
		public function get isRight():Boolean {return _isRight;}
		public function set isRight(value:Boolean):void {_isRight = value;}
	}

}