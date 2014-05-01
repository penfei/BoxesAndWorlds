package boxesandworlds.game.objects 
{
	import boxesandworlds.game.controller.Game;
	import flash.display.Sprite;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class GameObjectData
	{
		static private const OFFSET_X:Number = -2.9;
		static private const OFFSET_Y:Number = -7;
		static public const BOX_SHAPE:String = "BOX_SHAPE";
		static public const CIRCLE_SHAPE:String = "CIRCLE_SHAPE";
		static public const POINTS_SHAPE:String = "POINTS_SHAPE";
		
		private var _bodyShapeType:String;
		private var _bodyType:BodyType;
		private var _startPosition:Vec2;
		private var _shapePoints:Array;
		private var _width:Number;
		private var _height:Number;
		private var _container:Sprite;
		private var _id:uint;
		private var _type:String;
		private var _startAngle:Number;
		private var _density:Number;
		private var _dynamicFriction:Number;
		private var _staticFriction:Number;
		private var _elasticity:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _startLV:Vec2;
		private var _isDestroyPhysic:Boolean;
		private var _mass:Number;
		private var _offsetPoint:Vec2;
		
		protected var game:Game;
		
		public function GameObjectData(game:Game) 
		{
			this.game = game;
		}
		
		public function init(params:Object):void 
		{
			if (params.start) _startPosition = params.start;
			else _startPosition = new Vec2();
			if (params.angle) _startAngle = params.angle;
			else _startAngle = 0;
			if (params.startLV) _startLV = params.startLV;
			else _startLV = new Vec2;
			_offsetX = OFFSET_X;
			_offsetY = OFFSET_Y;
			_isDestroyPhysic = false;
			_offsetPoint = new Vec2;
		}
		
		public function get bodyShapeType():String {return _bodyShapeType;}
		public function set bodyShapeType(value:String):void {_bodyShapeType = value;}
		public function get bodyType():BodyType {return _bodyType;}
		public function set bodyType(value:BodyType):void {_bodyType = value;}
		public function get startPosition():Vec2 {return _startPosition;}
		public function set startPosition(value:Vec2):void { _startPosition = value; }
		public function get width():Number {return _width;}
		public function get height():Number {return _height;}
		public function set width(value:Number):void {_width = value;}
		public function set height(value:Number):void {_height = value;}
		public function get container():Sprite {return _container;}
		public function set container(value:Sprite):void {_container = value;}
		public function get shapePoints():Array {return _shapePoints;}
		public function set shapePoints(value:Array):void {_shapePoints = value;}
		public function get id():uint {return _id;}
		public function set id(value:uint):void {_id = value;}
		public function get type():String {return _type;}
		public function set type(value:String):void {_type = value;}
		public function get startAngle():Number {return _startAngle;}
		public function set startAngle(value:Number):void {_startAngle = value;}
		public function get density():Number {return _density;}
		public function set density(value:Number):void{_density = value;}
		public function get dynamicFriction():Number {return _dynamicFriction;}
		public function set dynamicFriction(value:Number):void{_dynamicFriction = value;}
		public function get elasticity():Number {return _elasticity;}
		public function set elasticity(value:Number):void{_elasticity = value;}
		public function get offsetX():Number {return _offsetX;}
		public function set offsetX(value:Number):void{_offsetX = value;}
		public function get offsetY():Number {return _offsetY;}
		public function set offsetY(value:Number):void{_offsetY = value;}
		public function get startLV():Vec2 {return _startLV;}
		public function set startLV(value:Vec2):void {_startLV = value;}
		public function get isDestroyPhysic():Boolean {return _isDestroyPhysic;}
		public function set isDestroyPhysic(value:Boolean):void {_isDestroyPhysic = value;}
		public function get mass():Number {return _mass;}
		public function set mass(value:Number):void {_mass = value;}
		public function get staticFriction():Number {return _staticFriction;}
		public function set staticFriction(value:Number):void {_staticFriction = value;}
		public function get offsetPoint():Vec2 {return _offsetPoint;}
		public function set offsetPoint(value:Vec2):void {_offsetPoint = value;}
		
	}

}