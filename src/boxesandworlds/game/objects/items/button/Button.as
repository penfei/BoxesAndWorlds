package boxesandworlds.game.objects.items.button 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	/**
	 * ...
	 * @author Sah
	 */
	public class Button extends GameObject
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
			_properties = data as ButtonData;
			_properties.init(params);
			
			_view = new ButtonView(game, this, params.ui);
			view = _view;
			initPhysics();
			initView()
			
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