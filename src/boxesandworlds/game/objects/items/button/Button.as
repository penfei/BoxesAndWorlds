package boxesandworlds.game.objects.items.button 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.items.Item;
	import boxesandworlds.game.objects.items.ItemData;
	/**
	 * ...
	 * @author Sah
	 */
	public class Button extends Item
	{
		private var _view:ButtonView;
		private var _properties:ButtonData;
		
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
			
			_view = new ButtonView(game, this, params.ui);
			itemView = _view;
			view = _view;
			
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
			body.cbTypes.add(game.physics.buttonType);
		}
		
		override public function destroy():void {
			super.destroy();
			if (_view) {
				_view.destroy();
				_view = null;
			}
		}
		
	}

}