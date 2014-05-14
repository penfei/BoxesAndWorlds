package boxesandworlds.game.objects.items.worldBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObjectData;
	import boxesandworlds.game.objects.items.ItemData;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldBoxData extends ItemData
	{
		private var _childWorldId:uint;
		private var _worldBoxAreaIndentX:Number;
		private var _worldBoxAreaIndentY:Number;
		
		public function WorldBoxData(game:Game) 
		{
			super(game);
		}
		
		override public function init(params:Object):void 
		{
			super.init(params);
			type = "WorldBox";
			bodyType = BodyType.DYNAMIC;
			width = 40;
			height = 40;
			container = game.gui.container;
			bodyShapeType = GameObjectData.BOX_SHAPE;
			elasticity = 0.4;
			dynamicFriction = 1;
			staticFriction = 2;
			density = 10;
			canTeleport = true;
			needButtonToTeleport = true;
			_worldBoxAreaIndentX = 20;
			_worldBoxAreaIndentY = 20;
			super.parse(params);
		}
		
		public function get childWorldId():uint {return _childWorldId;}
		public function set childWorldId(value:uint):void { _childWorldId = value; }
		public function get worldBoxAreaIndentX():Number {return _worldBoxAreaIndentX;}
		public function set worldBoxAreaIndentX(value:Number):void {_worldBoxAreaIndentX = value;}
		public function get worldBoxAreaIndentY():Number {return _worldBoxAreaIndentY;}
		public function set worldBoxAreaIndentY(value:Number):void { _worldBoxAreaIndentY = value; }
	}

}