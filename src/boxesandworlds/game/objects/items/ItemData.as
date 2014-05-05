package boxesandworlds.game.objects.items 
{
	import boxesandworlds.game.controller.Game;
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
		
		override public function init(params:Object):void 
		{
			_canAdded = true;
			super.init(params);
		}
		
		public function get canAdded():Boolean {return _canAdded;}
		public function set canAdded(value:Boolean):void {_canAdded = value;}
		
	}

}