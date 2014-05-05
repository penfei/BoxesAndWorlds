package boxesandworlds.controller {
	/**
	 * ...
	 * @author Sah
	 */
	public class Core 
	{
		private static var _instance:Core;
		private var _ui:UIManager;
		private var _data:DataManager;
		
		public function Core() 
		{
			
		}
		
		public static function get instance():Core {
			if (!_instance) {
				_instance = new Core;
			}

			return _instance;
		}
		
		public static function get data():DataManager {
			return instance._data;
		}

		public static function set data(value:DataManager):void {
			instance._data = value;
		}

		public static function get ui():UIManager {
			return instance._ui;
		}

		public static function set ui(value:UIManager):void {
			instance._ui = value;
		}
		
		public static function init():void {
			data.init()
		}

	}

}