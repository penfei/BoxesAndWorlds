package boxesandworlds.game.objects.items.worldBox 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.Enter;
	import boxesandworlds.game.objects.items.ItemView;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.text.TextField;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldBoxView extends ItemView
	{
		private var _ui:Sprite;
		private var _box:WorldBox;
		private var _connectedEdgeContainer:Sprite;
		private var _hintContainer:Sprite;
		
		public function WorldBoxView(game:Game, box:WorldBox) 
		{
			_box = box;
			super(game, box);
		}
		
		override public function init():void {
			_ui = new Sprite();
			_ui.graphics.beginFill(0x000099);
			_ui.graphics.drawRect( -obj.data.width / 2, -obj.data.height / 2, obj.data.width, obj.data.height);
			_ui.graphics.beginFill(0xFF00FF);
			_ui.graphics.drawRect(-obj.data.width / 6, -obj.data.height / 2, obj.data.width / 3, obj.data.height * 0.7);
			
			_connectedEdgeContainer = new Sprite();
			_connectedEdgeContainer.graphics.beginFill(0xdc23c0);
			_connectedEdgeContainer.graphics.drawCircle(0, 0, 4);
			_connectedEdgeContainer.alpha = 0;
			_ui.addChild(_connectedEdgeContainer);
			
			_hintContainer = new Sprite();
			_hintContainer.graphics.beginFill(0xCC9900);
			_hintContainer.graphics.drawCircle(0, 0, 5);
			_hintContainer.alpha = 0;
			_ui.addChild(_hintContainer);
			
			obj.data.views.push(_ui);
			obj.data.containerIds[0] = 0;
			super.init();
		}
		
		override public function showHintTeleport():void 
		{
			if (game.objects.me.potencialTeleport is Enter) {
				var enter:Enter = game.objects.me.potencialTeleport as Enter
				var p:Vec2 = _box.getPointByEdge(enter.enterData.edge);
				_hintContainer.alpha = 1;
				_hintContainer.x = p.x;
				_hintContainer.y = p.y;
				TweenLite.killTweensOf(_hintContainer);
				TweenLite.to(_hintContainer, 1, { alpha:0 } );
			}
		}
		
		public function postInit():void 
		{
			var text:TextField = new TextField();
			text.text = _box.childWorld.data.id.toString();
			_ui.addChild(text);
			
			var enters:Array = _box.childWorld.getOjbjectsByType(Enter);
			
			for each(var enter:Enter in enters) {
				_ui.graphics.beginFill(0x43664d);
				var p:Vec2 = _box.getPointByEdge(enter.enterData.edge);
				_ui.graphics.drawCircle( p.x, p.y, 3);
			}
		}
		
		public function showConnectedEdge():void 
		{
			var p:Vec2 = _box.getPointByEdge(_box.connectedEdge);
			_connectedEdgeContainer.alpha = 1;
			_connectedEdgeContainer.x = p.x;
			_connectedEdgeContainer.y = p.y;
			TweenLite.killTweensOf(_connectedEdgeContainer);
			TweenLite.to(_connectedEdgeContainer, 1, { alpha:0 } );
		}
	}

}