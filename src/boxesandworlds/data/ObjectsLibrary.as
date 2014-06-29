package boxesandworlds.data 
{
	import boxesandworlds.game.objects.door.DoorData;
	import boxesandworlds.game.objects.enters.edgeDoor.EdgeDoorData;
	import boxesandworlds.game.objects.enters.gate.GateData;
	import boxesandworlds.game.objects.items.box.BoxData;
	import boxesandworlds.game.objects.items.button.ButtonData;
	import boxesandworlds.game.objects.items.key.KeyData;
	import boxesandworlds.game.objects.items.teleportBox.TeleportBoxData;
	import boxesandworlds.game.objects.items.worldBox.WorldBoxData;
	import boxesandworlds.game.objects.worldstructrure.WorldStructureData;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Sah
	 */
	public class ObjectsLibrary 
	{
		static public const objectDatas:Array = [WorldStructureData, BoxData, TeleportBoxData, WorldBoxData, ButtonData, GateData, EdgeDoorData, KeyData, DoorData];
		static private var objectsByType:Object = {};
		
		public function ObjectsLibrary() 
		{
			
		}
		
		static public function init():void {
			var type:String;
			var path:String;
			var fullPath:String;
			for each(var objectDataClass:Class in objectDatas) {
				fullPath = getQualifiedClassName(objectDataClass);
				path = fullPath.slice(0, fullPath.length - 4);
				type = fullPath.slice(fullPath.search("::") + 2, fullPath.length - 4);
				
				objectsByType[type] = getDefinitionByName(path);
			}
		}
		
		static public function getObjectClassByType(type:String):Class
		{
			return objectsByType[type];
		}
		
	}

}