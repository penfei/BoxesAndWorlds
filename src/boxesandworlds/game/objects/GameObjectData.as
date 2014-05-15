package boxesandworlds.game.objects 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
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
		private var _start:Vec2;
		private var _shapePoints:Array;
		private var _width:Number;
		private var _height:Number;
		private var _containerId:uint;
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
		private var _teleportId:uint;
		private var _canTeleport:Boolean;
		private var _needButtonToTeleport:Boolean;
		
		protected var game:Game;
		
		public function GameObjectData(game:Game) 
		{
			this.game = game;
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = new Vector.<Attribute>();
			Attribute.pushAttribute(arr, "id", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "containerId", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "start", Vec2.weak(), Attribute.VEC2);
			Attribute.pushAttribute(arr, "startAngle", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "startLV", Vec2.weak(), Attribute.VEC2);
			Attribute.pushAttribute(arr, "elasticity", 0, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "dynamicFriction", 1, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "staticFriction", 2, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "density", 1, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "offsetX", OFFSET_X, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "offsetY", OFFSET_Y, Attribute.NUMBER);
			Attribute.pushAttribute(arr, "isDestroyPhysic", false, Attribute.BOOL, false);
			Attribute.pushAttribute(arr, "needButtonToTeleport", false, Attribute.BOOL);
			Attribute.pushAttribute(arr, "canTeleport", false, Attribute.BOOL);
			return arr;
		}
		
		public function init(params:Object):void 
		{
			var obj:Object = getAttributes();
			for each(var attribute:Attribute in obj) {
				this[attribute.name] = attribute.value;
			}
			
			for (var key:String in params) {
				this[key] = params[key];
			}
			container = game.gui.container;
		}
		
		protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
		
		public function get bodyShapeType():String {return _bodyShapeType;}
		public function set bodyShapeType(value:String):void {_bodyShapeType = value;}
		public function get bodyType():BodyType {return _bodyType;}
		public function set bodyType(value:BodyType):void {_bodyType = value;}
		public function get start():Vec2 {return _start;}
		public function set start(value:Vec2):void { _start = value; }
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
		public function get teleportId():uint {return _teleportId;}
		public function set teleportId(value:uint):void { _teleportId = value; }
		public function get canTeleport():Boolean {return _canTeleport;}
		public function set canTeleport(value:Boolean):void {_canTeleport = value;}
		public function get needButtonToTeleport():Boolean {return _needButtonToTeleport;}
		public function set needButtonToTeleport(value:Boolean):void {_needButtonToTeleport = value;}
		public function get containerId():uint {return _containerId;}
		public function set containerId(value:uint):void {_containerId = value;}
	}

}