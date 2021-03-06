package boxesandworlds.game.objects.items 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.objects.GameObjectData;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class ItemData extends GameObjectData
	{
		private var _canAdded:Boolean;
		private var _canTelekinesis:Boolean;
		public var addedOffset:Vec2;
		
		public function ItemData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "canAdded", true, Attribute.BOOL);
			Attribute.pushAttribute(arr, "canTelekinesis", true, Attribute.BOOL);
			Attribute.pushAttribute(arr, "addedOffset", Vec2.weak(), Attribute.VEC2);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
		
		public function get canAdded():Boolean {return _canAdded;}
		public function set canAdded(value:Boolean):void {_canAdded = value;}
		public function get canTelekinesis():Boolean {return _canTelekinesis;}
		public function set canTelekinesis(value:Boolean):void {_canTelekinesis = value;}
		
	}

}