package boxesandworlds.editor.area {
	import boxesandworlds.controller.Core;
	import boxesandworlds.editor.controls.EditorVerticalScroller;
	import boxesandworlds.editor.events.EditorEventWorld;
	import boxesandworlds.editor.items.EditorWorldPreview;
	import editor.EditorScrollWorldsUI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorAreaWorlds extends Sprite {
		
		// ui
		private var _btnAddWorld:MovieClip;
		private var _btnRemoveWorld:MovieClip;
		private var _btnSortWorlds:MovieClip;
		
		private var _worlds:Vector.<EditorWorldPreview>;
		private var _currentWorld:EditorWorldPreview;
		
		private var _scroll:EditorVerticalScroller;
		
		public function EditorAreaWorlds(btnAddWorld:MovieClip, btnRemoveWorld:MovieClip, btnSortWorlds:MovieClip) {
			_btnAddWorld = btnAddWorld;
			_btnRemoveWorld = btnRemoveWorld;
			_btnSortWorlds = btnSortWorlds;
			setup();
		}
		
		// protected
		protected function setup():void {
			_btnAddWorld.buttonMode = _btnRemoveWorld.buttonMode = _btnSortWorlds.buttonMode = true;
			_btnAddWorld.addEventListener(MouseEvent.CLICK, btnAddWorldClickHandler);
			_btnRemoveWorld.addEventListener(MouseEvent.CLICK, btnRemoveWorldClickHandler);
			_btnSortWorlds.addEventListener(MouseEvent.CLICK, btnSortWorldsClickHandler);
			
			_worlds = new Vector.<EditorWorldPreview>();
			addWorld();
			
			var content:Sprite = new Sprite();
			setupPositionsWorlds(content);
			_scroll = new EditorVerticalScroller(new EditorScrollWorldsUI, content, Core.stage);
			addChild(_scroll);
		}
		
		protected function setupPositionsWorlds(content:Sprite):void {
			var len:uint = _worlds.length;
			for (var i:uint = 0; i < len; ++i) {
				_worlds[i].x = 25 + 10 * (i % 4) + 55 * (i % 4);
				_worlds[i].y = 14 + 10 * (int(i / 4)) + 45 * (int(i / 4));
				content.addChild(_worlds[i]);
			}
			if (len > 8) {
				var s:Sprite = new Sprite();
				s.graphics.beginFill(0x000000, 0);
				s.graphics.drawRect(0, 0, 1, 40);
				s.graphics.endFill();
				s.y = content.height;
				content.addChildAt(s, 0);
			}
		}
		
		protected function addWorld():int {
			var id:int = getFreeId();
			var world:EditorWorldPreview = new EditorWorldPreview(id);
			world.buttonMode = true;
			world.addEventListener(MouseEvent.MOUSE_DOWN, worldDownHandler);
			world.setupSelect(true);
			_worlds.push(world);
			if (_currentWorld != null) {
				_currentWorld.setupSelect(false);
			}
			_currentWorld = world;
			return id;
		}
		
		protected function getFreeId():int {
			var len:uint = _worlds.length;
			var ids:Vector.<int> = new Vector.<int>();
			ids.length = len;
			for (var i:int = 0; i < len; ++i) {
				ids[i] = _worlds[i].id;
			}
			ids.sort(sortIds);
			for (var j:int = 0; j < len; ++j) {
				if (ids[j] != j) {
					return j;
				}
			}
			return len;
		}
		
		protected function sortIds(value1:int, value2:int):int {
			if (value1 < value2) return -1;
			if (value1 == value2) return 0;
			return 1;
		}
		
		protected function sortWorlds(value1:EditorWorldPreview, value2:EditorWorldPreview):int {
			if (value1.id < value2.id) return -1;
			if (value1.id == value2.id) return 0;
			return 1;
		}
		
		// handlers
		private function btnAddWorldClickHandler(e:MouseEvent):void {
			var id:int = addWorld();
			var content:Sprite = new Sprite();
			setupPositionsWorlds(content);
			_scroll.replaceContent(content);
			_scroll.setupContentDown();
			
			dispatchEvent(new EditorEventWorld(EditorEventWorld.ADD_WORLD, id));
		}
		
		private function btnRemoveWorldClickHandler(e:MouseEvent):void {
			if (_currentWorld != null && _worlds.length > 1) {
				var idRemove:int = _currentWorld.id;
				for (var i:uint = 0, len:uint = _worlds.length; i < len; ++i) {
					if (_currentWorld == _worlds[i]) {
						_worlds.splice(i, 1);
						_currentWorld.parent.removeChild(_currentWorld);
						_currentWorld.destroy();
						if (i < len - 1) {
							_currentWorld = _worlds[i];
						}else {
							_currentWorld = _worlds[i - 1];
						}
						_currentWorld.setupSelect(true);
						break;
					}
				}
				var content:Sprite = new Sprite();
				setupPositionsWorlds(content);
				_scroll.replaceContent(content);
				dispatchEvent(new EditorEventWorld(EditorEventWorld.REMOVE_WORLD, idRemove, _currentWorld.id));
			}
		}
		
		private function btnSortWorldsClickHandler(e:MouseEvent):void {
			_worlds.sort(sortWorlds);
			var content:Sprite = new Sprite();
			setupPositionsWorlds(content);
			_scroll.replaceContent(content);
		}
		
		private function worldDownHandler(e:MouseEvent):void {
			var world:EditorWorldPreview = e.currentTarget as EditorWorldPreview;
			if (world != null && world != _currentWorld) {
				_currentWorld.setupSelect(false);
				_currentWorld = world;
				_currentWorld.setupSelect(true);
				dispatchEvent(new EditorEventWorld(EditorEventWorld.SELECT_WORLD, world.id));
			}
		}
		
	}

}