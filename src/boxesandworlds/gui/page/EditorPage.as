package boxesandworlds.gui.page {
	import boxesandworlds.controller.Core;
	import boxesandworlds.controller.UIManager;
	import boxesandworlds.editor.area.EditorAreaAttributes;
	import boxesandworlds.editor.area.EditorAreaItems;
	import boxesandworlds.editor.area.EditorAreaWorld;
	import boxesandworlds.editor.area.EditorAreaWorlds;
	import boxesandworlds.editor.EditorPopup;
	import boxesandworlds.editor.events.EditorEventAttributes;
	import boxesandworlds.editor.events.EditorEventNewItem;
	import boxesandworlds.editor.events.EditorEventWorld;
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
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorPage extends Page {
		
		// ui
		private var _ui:EditorPageUI;
		private var _popup:EditorPopup;
		private var _areaWorld:EditorAreaWorld;
		private var _areaWorlds:EditorAreaWorlds;
		private var _areaItems:EditorAreaItems;
		private var _areaAttributes:EditorAreaAttributes;
		
		// vars
		private var _library:Array = [WorldStructureData, BoxData, TeleportBoxData, WorldBoxData, ButtonData, GateData, EdgeDoorData];
		
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
			
			_ui.btnSave.buttonMode = _ui.btnClear.buttonMode = _ui.btnExit.buttonMode = true;
			_ui.btnSave.addEventListener(MouseEvent.CLICK, btnSaveClickHandler);
			_ui.btnClear.addEventListener(MouseEvent.CLICK, btnClearClickHandler);
			_ui.btnExit.addEventListener(MouseEvent.CLICK, btnExitClickHandler);
			
			_areaWorld = new EditorAreaWorld();
			_areaWorld.addEventListener(EditorEventAttributes.SHOW_ATTRIBUTES, showAttributesHandler);
			_areaWorld.addEventListener(EditorEventAttributes.HIDE_ATTRIBUTES, hideAttributesHandler);
			_ui.areaWorld.addChild(_areaWorld);
			
			_areaWorlds = new EditorAreaWorlds(_ui.btnAddWorld, _ui.btnRemoveWorld, _ui.btnSortWorlds);
			_ui.areaWorlds.addChild(_areaWorlds);
			_areaWorlds.addEventListener(EditorEventWorld.ADD_WORLD, addWorldHandler);
			_areaWorlds.addEventListener(EditorEventWorld.REMOVE_WORLD, removeWorldHandler);
			_areaWorlds.addEventListener(EditorEventWorld.SELECT_WORLD, selectWorldHandler);
			
			_areaItems = new EditorAreaItems(_library);
			_ui.areaItems.addChild(_areaItems);
			_areaItems.addEventListener(EditorEventNewItem.NEW_ITEM, addNewItemHandler);
			
			Core.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
			
			_areaAttributes = new EditorAreaAttributes();
			_ui.areaAttributes.addChild(_areaAttributes);
			
			//setupTempPositions();
		}
		
		/* функция для калькулятора Бори */
		protected function setupTempPositions():void {
			var step:int = 100;
			_ui.btnSave.y = _ui.btnExit.y = _ui.btnClear.y = _ui.btnClear.y - step;
			_ui.bgButtons.y -= step;
		}
		
		protected function showPopup():void {
			_ui.mouseChildren = _ui.mouseEnabled = false;
			_popup.alpha = 0;
			_popup.y = _ui.y + (_ui.height - _popup.height) / 2 - 50;
			_popup.mouseChildren = _popup.mouseEnabled = true;
			TweenMax.to(_popup, .5, { y: _ui.y + (_ui.height - _popup.height) / 2, alpha:1, ease:Expo.easeOut } );
		}
		
		protected function hidePopup():void {
			_ui.mouseChildren = _ui.mouseEnabled = true;
			_popup.mouseChildren = _popup.mouseEnabled = false;
			TweenMax.to(_popup, .4, { y: _ui.y + (_ui.height - _popup.height) / 2 + 50, alpha:0, ease:Linear.easeNone } );
		}
		
		// handlers
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
		}
		
		private function popupClearLevelHandler(e:Event):void {
			hidePopup();
		}
		
		private function popupExitHandler(e:Event):void {
			Core.ui.showPage(UIManager.MAIN_PAGE_ID);
		}
		
		private function addNewItemHandler(e:EditorEventNewItem):void {
			_areaWorld.addItem(e.id, e.attributes);
		}
		
		private function addWorldHandler(e:EditorEventWorld):void {
			_areaWorld.addWorld(e.id);
		}
		
		private function removeWorldHandler(e:EditorEventWorld):void {
			_areaWorld.removeWorld(e.id, e.addId);
		}
		
		private function selectWorldHandler(e:EditorEventWorld):void {
			_areaWorld.selectWorld(e.id);
		}
		
		private function showAttributesHandler(e:EditorEventAttributes):void {
			_areaAttributes.showAttributes(e.item);
		}
		
		private function hideAttributesHandler(e:EditorEventAttributes):void {
			_areaAttributes.hideAttributes();
			_areaWorld.unselectItem();
		}
		
		private function stageClickHandler(e:MouseEvent):void {
			if (e.target.parent != null && e.target.parent as EditorPageUI != null) {
				_areaAttributes.hideAttributes();
				_areaWorld.unselectItem();
			}
		}
		
	}
	
}