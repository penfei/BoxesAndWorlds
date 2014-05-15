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
		
		public static function attributes():Object
		{
			var obj:Object = GameObjectData.attributes();
			Attribute.pushAttribute(obj, "canAdded", true, Attribute.BOOL);
			return obj;
		}
		
		override protected function getAttributes():Object {
			return attributes();
		}
		
		public function get canAdded():Boolean {return _canAdded;}
		public function set canAdded(value:Boolean):void {_canAdded = value;}
		
	}

}