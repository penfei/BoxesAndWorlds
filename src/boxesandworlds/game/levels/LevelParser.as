package boxesandworlds.game.levels
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.button.Button;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author Sah
	 */
	public class LevelParser 
	{
		private var _game:Game;
		private var _parsedObjects:Vector.<Object>;
		private var _isParsed:Boolean;
		
		public function LevelParser(game:Game) 
		{
			_isParsed = false;
			_game = game;
		}
		
		
		public function parse():void {
			if(!_isParsed){
				_parsedObjects = new Vector.<Object>;
				
				//for ( var i:uint = 0; i < _ui.numChildren; i++ ) {
					//var itemName:String = _ui.getChildAt(i).name;
					//if (itemName.split("_")[0] == "button") createButton(_ui.getChildAt(i), _ui.getChildAt(i).name);
				//}
				for each(var item:Object in _parsedObjects)
					item.obj.init(item.params);
					
				_isParsed = true;
			}
		}
		
		private function createButton(mc:DisplayObject, name:String):void 
		{
			var start:Vec2 = new Vec2(mc.x, mc.y);
			var params:Object = { type:name.split("_")[0], id:Number(name.split("_")[1]), ui:mc, bodyType:BodyType.STATIC, start:start };
			var obj:Button = new Button(_game);
			add(obj, params);
		}
		
		private function add(obj:GameObject, params:Object):void {
			_parsedObjects.push({obj:obj, params:params});
		}		
	}

}