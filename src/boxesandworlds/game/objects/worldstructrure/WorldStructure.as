package boxesandworlds.game.objects.worldstructrure 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.world.World;
	import nape.phys.Body;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldStructure extends GameObject
	{
		private var _view:WorldStructureView;
		private var _properties:WorldStructureData;
		
		public function WorldStructure(game:Game) 
		{
			super(game);
		}
		
		public function get structureData():WorldStructureData {return _properties;}
		public function set structureData(value:WorldStructureData):void {_properties = value;}
		public function get structureView():WorldStructureView {return _view;}
		public function set structureView(value:WorldStructureView):void { _view = value; }
		
		override public function init(params:Object = null):void {
			data = new WorldStructureData(game);
			_properties = data as WorldStructureData;
			data.init(params);
			
			_view = new WorldStructureView(game, this);
			view = _view;
			if (!_properties.isEmpty) {
				super.init();
			}
			else {
				initPhysics();
				initView();
			}
		}
		
		override protected function initPhysics():void {
			if (!_properties.isEmpty) {
				super.initPhysics();
			} else {
				body = new Body(_properties.bodyType, _properties.start);
				body.userData.obj = this;
			}
		}
		
		override public function loadLevel(save:Object):void {
			if (save.world != null) {
				body.space = null;
				body.position.setxy(save.posX, save.posY);
				body.rotation = save.rotation;
				body.space = game.physics.world;
			}
		}
		
		override public function addToWorld(w:World):void {
			w.structure = this;
			super.addToWorld(w);
			
			w.initWorldBody();
		}
		
		override public function postInit():void 
		{
			super.postInit();
			checkWorldVisible();
		}
		
	}

}
