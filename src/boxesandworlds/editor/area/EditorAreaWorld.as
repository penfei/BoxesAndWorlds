package boxesandworlds.editor.area {
	import boxesandworlds.editor.events.EditorEventAttributes;
	import boxesandworlds.editor.items.EditorWorld;
	import boxesandworlds.game.data.Attribute;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaWorld extends Sprite {
		
		// ui
		private var _currentWorld:EditorWorld;
		private var _worlds:Vector.<EditorWorld>;
		
		public function EditorAreaWorld() {
			setup();
		}
		
		// public
		public function addWorld(id:int):void {
			unselectItem();
			if (_currentWorld != null && _currentWorld.parent != null) {
				_currentWorld.parent.removeChild(_currentWorld);
			}
			var world:EditorWorld = new EditorWorld(id);
			_worlds.push(world);
			_currentWorld = world;
			addChild(_currentWorld);
		}
		
		public function removeWorld(id:int, selectId:int):void {
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].id == id) {
					var world:EditorWorld = _worlds[i];
					world.destroy();
					if (world.parent != null) {
						world.parent.removeChild(world);
					}
					world = null;
					_worlds.splice(i, 1);
					selectWorld(selectId);
					return;
				}
			}
		}
		
		public function selectWorld(id:int):void {
			for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
				if (_worlds[i].id == id) {
					if (_currentWorld != null) {
						unselectItem();
						dispatchEvent(new EditorEventAttributes(EditorEventAttributes.HIDE_ATTRIBUTES));
						_currentWorld.visible = false;
						if (_currentWorld.parent != null) {
							_currentWorld.parent.removeChild(_currentWorld);
						}
					}
					_currentWorld = _worlds[i];
					_currentWorld.visible = true;
					addChild(_currentWorld);
					return;
				}
			}
		}
		
		public function addItem(id:String, attributes:Vector.<Attribute>):void {
			_currentWorld.addItem(id, attributes);
		}
		
		public function unselectItem():void {
			if (_currentWorld != null) {
				_currentWorld.setupSelectableItem();
			}
		}
		
		// protected
		protected function setup():void {
			_worlds = new Vector.<EditorWorld>();
			addWorld(0);
		}
		
		// handlers
		
	}
	
}