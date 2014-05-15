package boxesandworlds.game.objects.items 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.objects.GameObjectData;
	/**
	 * ...
	 * @author Sah
	 */
	public class ItemData extends GameObjectData
	{
		private var _canAdded:Boolean;
		
		public function ItemData(game:Game) 
		{
			super(game);
		}
		
		public static function attributes():Vector.<Attribute>
		{
			var arr:Vector.<Attribute> = GameObjectData.attributes();
			Attribute.pushAttribute(arr, "canAdded", true, Attribute.BOOL);
			return arr;
		}
		
		override protected function getAttributes():Vector.<Attribute> {
			return attributes();
		}
		
		public function get canAdded():Boolean {return _canAdded;}
		public function set canAdded(value:Boolean):void {_canAdded = value;}
		
	}

}