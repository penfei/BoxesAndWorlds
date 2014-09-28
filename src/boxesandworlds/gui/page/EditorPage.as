package boxesandworlds.gui.page {
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.UIManager;
	import boxesandworlds.data.ObjectsLibrary;
	import boxesandworlds.editor.area.EditorAreaAttributes;
	import boxesandworlds.editor.area.EditorAreaItems;
	import boxesandworlds.editor.area.EditorAreaScript;
	import boxesandworlds.editor.area.EditorAreaWorld;
	import boxesandworlds.editor.area.EditorAreaWorlds;
	import boxesandworlds.editor.data.EditorLevelData;
	import boxesandworlds.editor.data.EditorXMLLoader;
	import boxesandworlds.editor.EditorPopup;
	import boxesandworlds.editor.events.EditorEventChangeAttributeStart;
	import boxesandworlds.editor.events.EditorEventNewItem;
	import boxesandworlds.editor.events.EditorEventPlayer;
	import boxesandworlds.editor.events.EditorEventWorld;
	import boxesandworlds.editor.items.EditorItem;
	import boxesandworlds.editor.TestScript;
	import boxesandworlds.editor.utils.EditorUtils;
	import boxesandworlds.editor.data.EditorXMLLoader;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.objects.enters.edgeDoor.EdgeDoorData;
	import boxesandworlds.game.objects.enters.gate.GateData;
	import boxesandworlds.game.objects.items.box.BoxData;
	import boxesandworlds.game.objects.items.button.ButtonData;
	import boxesandworlds.game.objects.items.teleportBox.TeleportBoxData;
	import boxesandworlds.game.objects.items.worldBox.WorldBoxData;
	import boxesandworlds.game.objects.worldstructrure.WorldStructureData;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import editor.EditorPageUI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorPage extends Page {
		
		static private const SCRIPTS:Array = [Level, TestScript];
		
		// ui
		private var _ui:EditorPageUI;
		private var _popup:EditorPopup;
		private var _areaWorld:EditorAreaWorld;
		private var _areaWorlds:EditorAreaWorlds;
		private var _areaItems:EditorAreaItems;
		private var _areaAttributes:EditorAreaAttributes;
		private var _areaScript:EditorAreaScript;
		
		// vars
		private var _isSetupPlayer:Boolean;
		private var _xmlLoader:EditorXMLLoader;
		
		public function EditorPage() {
			super(UIManager.EDITOR_PAGE_ID);
		}
		
		// public
		override public function setup():void {
			_ui = new EditorPageUI;
			addChild(_ui);
			
			_popup = new EditorPopup;
			_popup.x = _ui.x + (_ui.width - _popup.width) / 2;
			_popup.alpha = 0;
			_popup.mouseChildren = _popup.mouseEnabled = false;
			addChild(_popup);
			_popup.addEventListener(EditorPopup.EDITOR_CANCEL_POPUP, popupCancelHandler);
			_popup.addEventListener(EditorPopup.EDITOR_SAVE_LEVEL, popupSaveLevelHandler);
			_popup.addEventListener(EditorPopup.EDITOR_CLEAR_LEVEL, popupClearLevelHandler);
			_popup.addEventListener(EditorPopup.EDITOR_EXIT, popupExitHandler);
			
			_ui.btnLoad.buttonMode = _ui.btnSave.buttonMode = _ui.btnClear.buttonMode = _ui.btnExit.buttonMode = true;
			_ui.btnLoad.addEventListener(MouseEvent.CLICK, btnLoadClickHandler);
			_ui.btnSave.addEventListener(MouseEvent.CLICK, btnSaveClickHandler);
			_ui.btnClear.addEventListener(MouseEvent.CLICK, btnClearClickHandler);
			_ui.btnExit.addEventListener(MouseEvent.CLICK, btnExitClickHandler);
			
			_areaWorld = new EditorAreaWorld(this);
			_areaWorld.addEventListener(EditorEventPlayer.PLAYER_NOT_SETUP, playerNotSetupHandler);
			_ui.areaWorld.contWorld.addChild(_areaWorld);
			_ui.areaWorld.bg.addEventListener(MouseEvent.MOUSE_DOWN, bgWorldDownHandler);
			Core.stage.addEventListener(MouseEvent.MOUSE_UP, bgWorldUpHandler);
			Core.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownWorldHandler);
			
			_areaWorlds = new EditorAreaWorlds(_ui.btnAddWorld, _ui.btnRemoveWorld, _ui.btnSortWorlds);
			_ui.areaWorlds.addChild(_areaWorlds);
			_areaWorlds.addEventListener(EditorEventWorld.ADD_WORLD, addWorldHandler);
			_areaWorlds.addEventListener(EditorEventWorld.REMOVE_WORLD, removeWorldHandler);
			_areaWorlds.addEventListener(EditorEventWorld.SELECT_WORLD, selectWorldHandler);
			
			_areaItems = new EditorAreaItems(ObjectsLibrary.objectDatas);
			_ui.areaItems.addChild(_areaItems);
			_areaItems.addEventListener(EditorEventNewItem.NEW_ITEM, addNewItemHandler);
			
			_ui.player.buttonMode = true;
			_ui.player.addEventListener(MouseEvent.MOUSE_DOWN, playerDownHandler);
			_ui.player.addEventListener(MouseEvent.ROLL_OVER, playerOverHandler);
			_ui.player.addEventListener(MouseEvent.ROLL_OUT, playerOutHandler);
			enablePlayer();
			
			Core.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
			
			_areaAttributes = new EditorAreaAttributes();
			_areaAttributes.addEventListener(EditorEventChangeAttributeStart.CHANGE_ATTRIBUTE_START, changeAttributeStartHandler);
			_ui.areaAttributes.addChild(_areaAttributes);
			
			_areaScript = new EditorAreaScript();
			_ui.areaScript.addChild(_areaScript);
			_areaScript.addEventListener(EditorAreaScript.EDITOR_CHANGED_SCRIPT, changedScriptHandler);
			changedScriptHandler();
			
			//setupTempPositions();
		}
		
		public function showAttributes(item:EditorItem):void {
			_areaAttributes.showAttributes(item);
		}
		
		public function hideAttributes():void {
			_areaAttributes.hideAttributes();
			_areaWorld.unselectItem();
		}
		
		public function disablePlayer():void {
			_ui.player.mc.alpha = 0;
			_isSetupPlayer = true;
		}
		
		public function get containerWorld():MovieClip {
			return _ui.areaWorld.contWorld;
		}
		
		/* функция для калькулятора Бори */
		protected function setupTempPositions():void {
			var step:int = 100;
			_ui.btnLoad.y = _ui.btnSave.y = _ui.btnExit.y = _ui.btnClear.y = _ui.btnClear.y - step;
			_ui.bgButtons.y -= step;
		}
		
		protected function showPopup():void {
			_ui.mouseChildren = _ui.mouseEnabled = false;
			_popup.alpha = 0;
			_popup.y = (Core.stage.stageHeight - _popup.height) / 2 - 50;
			_popup.mouseChildren = _popup.mouseEnabled = true;
			TweenMax.to(_popup, .5, { y: (Core.stage.stageHeight - _popup.height) / 2, alpha:1, ease:Expo.easeOut } );
		}
		
		protected function hidePopup():void {
			_ui.mouseChildren = _ui.mouseEnabled = true;
			_popup.mouseChildren = _popup.mouseEnabled = false;
			TweenMax.to(_popup, .4, { y: (Core.stage.stageHeight - _popup.height) / 2 + 50, alpha:0, ease:Linear.easeNone } );
		}
		
		protected function saveXML():void {
			var xml:XML = <xml></xml>;
			xml = _areaScript.getLevelScriptXML(xml);
			xml = _areaWorld.getWorldsAndPlayerXML(xml);
			
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(xml);
			var fr:FileReference = new FileReference();
			fr.save(ba, EditorUtils.XML_NAME);
		}
		
		protected function enablePlayer():void {
			_ui.player.mc.alpha = 1;
			_isSetupPlayer = false;
		}
		
		// handlers
		private function bgWorldDownHandler(e:MouseEvent):void {
			hideAttributes();
			_ui.areaWorld.contWorld.startDrag();
		}
		
		private function bgWorldUpHandler(e:MouseEvent):void {
			_ui.areaWorld.contWorld.stopDrag();
		}
		
		private function keyDownWorldHandler(e:KeyboardEvent):void {
			if (Core.stage.focus != null && (Core.stage.focus as TextField) != null) {
				return;
			}
			if (e.keyCode == Keyboard.LEFT) {
				_ui.areaWorld.contWorld.x -= 20;
			}else if (e.keyCode == Keyboard.RIGHT) {
				_ui.areaWorld.contWorld.x += 20;
			}else if (e.keyCode == Keyboard.UP) {
				_ui.areaWorld.contWorld.y -= 20;
			}else if (e.keyCode == Keyboard.DOWN) {
				_ui.areaWorld.contWorld.y += 20;
			}
		}
		
		private function btnLoadClickHandler(e:MouseEvent):void {
			if (_xmlLoader == null) {
				_xmlLoader = new EditorXMLLoader();
			}
			_xmlLoader.addEventListener(EditorXMLLoader.XML_DATA_LOADED, xmlDataLoadedHandler);
			_xmlLoader.openWindow();
		}
		
		private function xmlDataLoadedHandler(e:Event):void {
			_xmlLoader.removeEventListener(EditorXMLLoader.XML_DATA_LOADED, xmlDataLoadedHandler);
			
			var levelData:EditorLevelData = _xmlLoader.levelData;
			_areaScript.levelScript = levelData.levelScriptData.levelScriptName;
			_areaWorlds.setupDataFromXML(levelData.worldsData);
			_areaWorld.setupDataFromXML(levelData.playerData, levelData.worldsData);
			_ui.areaWorld.contWorld.x = _ui.areaWorld.contWorld.y = 0;
		}
		
		private function btnSaveClickHandler(e:MouseEvent):void {
			_popup.setupType(EditorPopup.EDITOR_SAVE_LEVEL);
			showPopup();
		}
		
		private function btnClearClickHandler(e:MouseEvent):void {
			_popup.setupType(EditorPopup.EDITOR_CLEAR_LEVEL);
			showPopup();
		}
		
		private function btnExitClickHandler(e:MouseEvent):void {
			_popup.setupType(EditorPopup.EDITOR_EXIT);
			showPopup();
		}
		
		private function popupCancelHandler(e:Event):void {
			hidePopup();
		}
		
		private function popupSaveLevelHandler(e:Event):void {
			hidePopup();
			saveXML();
		}
		
		private function popupClearLevelHandler(e:Event):void {
			hidePopup();
			_areaWorld.removeAllItems();
		}
		
		private function popupExitHandler(e:Event):void {
			Core.ui.showPage(UIManager.MAIN_PAGE_ID);
		}
		
		private function addNewItemHandler(e:EditorEventNewItem):void {
			_areaWorld.addItem(e.attributes);
		}
		
		private function addWorldHandler(e:EditorEventWorld):void {
			_areaWorld.addWorld(e.id);
		}
		
		private function removeWorldHandler(e:EditorEventWorld):void {
			_areaWorld.removeWorld(e.id, e.nextId);
		}
		
		private function selectWorldHandler(e:EditorEventWorld):void {
			_areaWorld.selectWorld(e.id);
		}
		
		private function playerDownHandler(e:MouseEvent):void {
			_areaAttributes.hideAttributes();
			_areaWorld.unselectItem();
			_areaWorld.addPlayer();
			disablePlayer();
		}
		
		private function playerNotSetupHandler(e:EditorEventPlayer):void {
			enablePlayer();
		}
		
		private function playerOverHandler(e:MouseEvent):void {
			if (_isSetupPlayer) {
				TweenMax.to(_ui.player.mc, .2, { alpha:.3 } );
			}
		}
		
		private function playerOutHandler(e:MouseEvent):void {
			if (_isSetupPlayer) {
				TweenMax.to(_ui.player.mc, .2, { alpha:0 } );
			}
		}
		
		private function stageClickHandler(e:MouseEvent):void {
			if (e.target.parent != null && e.target.parent as EditorPageUI != null) {
				_areaAttributes.hideAttributes();
				_areaWorld.unselectItem();
			}
		}
		
		private function changeAttributeStartHandler(e:EditorEventChangeAttributeStart):void {
			_areaWorld.setupPositionItem(e.valueX, e.valueY);
		}
		
		private function changedScriptHandler(e:Event = null):void {
			var layers:Vector.<Sprite>;
			try {
				layers = (getDefinitionByName("boxesandworlds.editor." + _areaScript.levelScript) as Class).layers();
				trace("Скрипт есть, контейнеры берутся из " + _areaScript.levelScript + ".");
			}catch(error:Error) {
				layers = (getDefinitionByName("boxesandworlds.game.levels.Level") as Class).layers();
				trace("Скрипта нет, контейнеры берутся из Level.");
			}
			_areaWorld.setupLayers(layers);
		}
		
	}
}