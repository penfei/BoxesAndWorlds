package boxesandworlds.game.objects.items.jumper 
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
	public class Jumper extends Item
	{
		private var _view:JumperView;
		private var _properties:JumperData;
		
		public function Jumper(game:Game) 
		{
			super(game);
		}
		
		public function get jumperData():JumperData {return _properties;}
		public function set jumperData(value:JumperData):void {_properties = value;}
		
		override public function init(params:Object = null):void {
			data = new JumperData(game);
			itemData = data as ItemData; 
			_properties = data as JumperData;
			_properties.init(params);
			
			_view = new JumperView(game, this);
			itemView = _view;
			view = _view;
			
			super.init();
			
			body.cbTypes.add(game.physics.collisionType);
			body.cbTypes.add(game.physics.jumperType);
		}
		
		public function addImpulse():void 
		{
			game.objects.me.playerData.jumperVelocity = _properties.power.copy();
			//game.objects.me.addImpulse(_properties.power.copy(true));
		}
	}

}