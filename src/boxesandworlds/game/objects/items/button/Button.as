package boxesandworlds.game.objects.items.button 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.door.Door;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.ItemData;
	import boxesandworlds.game.world.World;
	/**
	 * ...
	 * @author Sah
	 */
	public class Button extends Item
	{
		private var _view:ButtonView;
		private var _properties:ButtonData;
		private var _openedDoor:Door;
		
		private var _openedContacts:uint;
		
		public function Button(game:Game) 
		{
			super(game);
		}
		
		public function get buttonData():ButtonData {return _properties;}
		public function set buttonData(value:ButtonData):void {_properties = value;}
		
		override public function init(params:Object = null):void {
			data = new ButtonData(game);
			itemData = data as ItemData; 
			_properties = data as ButtonData;
			_properties.init(params);
			
			_view = new ButtonView(game, this);
			itemView = _view;
			view = _view;
			
			_openedContacts = 0;
			
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
			body.cbTypes.add(game.physics.buttonType);
		}
		
		override public function postInit():void 
		{
			super.postInit();
			
			if (_properties.openedId != 0) {
				for each(var world:World in game.objects.worlds) {
					for each(var obj:GameObject in world.objects) {
						if (obj.data.id == _properties.openedId) {
							_openedDoor = obj as Door;
						}
					}
				}
			}
		}
		
		public function openDoor():void {
			_openedContacts++;
			if (_openedContacts > 0) _openedDoor.temporarilyOpen();
		}
		
		public function closeDoor():void {
			_openedContacts--;
			if (_openedContacts == 0) _openedDoor.temporarilyClose();
		}
	}

}