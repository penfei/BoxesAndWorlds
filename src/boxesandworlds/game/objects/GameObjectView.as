package boxesandworlds.game.objects 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.gui.View;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Sah
	 */
	public class GameObjectView
	{
		protected var game:Game;
		protected var obj:GameObject;
		
		protected var views:Vector.<DisplayObject>;
		protected var index:uint;
		protected var len:uint;
		
		public function GameObjectView(game:Game, obj:GameObject) 
		{
			this.obj = obj;
			this.game = game;
			
			views = new Vector.<DisplayObject>;
			index = 0;
		}
		
		public function init():void {
			len = obj.data.views.length;
			for (index = 0; index < len; index++) {
				views.push(obj.data.views[index] as DisplayObject);
			}
		}
		
		public function updatePosition(dx:Number, dy:Number, rotation:Number):void{
			for (index = 0; index < len; index++) {
				views[index].x = dx;
				views[index].y = dy;
				views[index].rotation = rotation;
			}
		}
		
		public function checkWorldVisible():void {
			for (index = 0; index < len; index++) {
				if (obj.visible && views[index].parent == null) game.gui.layers[obj.data.containerIds[index]].addChild(views[index]);
				if (!obj.visible && views[index].parent != null) game.gui.layers[obj.data.containerIds[index]].removeChild(views[index]);
			}
		}
		
		public function step():void 
		{
			
		}
		
		public function destroy():void 
		{
			for (index = 0; index < len; index++) 
				if (views[index].parent != null) 
					views[index].parent.removeChild(views[index]); 
		}
		
		public function showHintTeleport():void 
		{
			
		}
		
	}

}