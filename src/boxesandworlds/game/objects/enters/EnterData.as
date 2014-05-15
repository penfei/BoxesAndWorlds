package boxesandworlds.game.objects.enters 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.objects.GameObjectData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class EnterData extends GameObjectData
	{	
		static public const LEFT:String = "LEFT";
		static public const RIGHT:String = "RIGHT";
		static public const TOP:String = "TOP";
		static public const BOTTOM:String = "BOTTOM";
		
		private var _isOpen:Boolean;
		private var _edge:String;
		
		public function EnterData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "isOpen", true, Attribute.BOOL);
			Attribute.pushAttribute(arr, "edge", LEFT, Attribute.STRING, true, true, [LEFT, RIGHT, TOP, BOTTOM]);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
		
		public function get isOpen():Boolean {return _isOpen;}
		public function set isOpen(value:Boolean):void {_isOpen = value;}
		public function get edge():String {return _edge;}
		public function set edge(value:String):void {_edge = value;}
	}

}