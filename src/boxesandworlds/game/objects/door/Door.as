package boxesandworlds.game.objects.door 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.key.Key;
	import boxesandworlds.game.world.World;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	/**
	 * ...
	 * @author Sah
	 */
	public class Door extends GameObject
	{
		private var _view:DoorView;
		private var _properties:DoorData;
		
		public function Door(game:Game) 
		{
			super(game);
		}
		
		public function get doorView():DoorView {return _view;}
		public function set doorView(value:DoorView):void {_view = value;}
		public function get doorData():DoorData {return _properties;}
		public function set doorData(value:DoorData):void {_properties = value;}
		
		override public function init(params:Object = null):void {
			data = new DoorData(game);
			_properties = data as DoorData;
			_properties.init(params);
			
			_view = new DoorView(game, this);
			view = _view;
			
			super.init();
			
			body.cbTypes.add(game.physics.doorType);
		}
		
		public function open():void 
		{
			if (!_properties.isOpen) {
				_properties.isOpen = true;
				body.shapes.at(0).filter.collisionMask = 0;
				_view.showOpen();
			}
		}
		
		public function temporarilyOpen():void 
		{
			if (!_properties.isOpen && !_properties.isTemporarilyOpen) {
				_properties.isTemporarilyOpen = true;
				body.shapes.at(0).filter.collisionMask = 0;
				_view.showOpen();
			}
		}
		
		public function temporarilyClose():void 
		{
			if (!_properties.isOpen && _properties.isTemporarilyOpen) {
				_properties.isTemporarilyOpen = false;
				body.shapes.at(0).filter.collisionMask = -1;
				_view.showClose();
			}
		}
	}

}