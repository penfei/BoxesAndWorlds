package boxesandworlds.editor
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	//import ru.snp.controller.SystemSettings;
	//import ru.snp.net.LoadingManager;
	
	/**
	 * ...
	 * @author Anton Kozhevnikov
	 * e-mail ak@saltpepper.ru
	 * ...
	 */	
	
	public class UploadFile extends EventDispatcher{
		
		public static const URL:String = "url"
		public static const FILE_REFERENCE:String = "file_reference";
		private var _type:String
		
		private var _reference:FileReference;
		private var _url:String;
		private var _ldr:Loader;
		public function UploadFile(reference:FileReference = null, url:String = null){
			if(reference!=null){
				_reference = reference;
				_type = FILE_REFERENCE;
			}else{
				_url = url;
				_type = URL;
			}
		}
		
		// public:
		public function download():void{
			
			_ldr = new Loader()
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true)
			
			if(_type == FILE_REFERENCE){
				loadReference()
			}else{
				loadUrl()
			}
			
			
			//LoadingManager.getInstance().addLoader()
			
		}
		
		public function destroy():void {
			if (_reference != null) {
				_reference.removeEventListener (Event.COMPLETE, referenceLoaded);
				_reference.cancel();
				_reference = null;
			}
			if (_ldr != null) {
				if (_ldr.contentLoaderInfo != null) {
					_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadingComplete);
				}
			}
		}
		
		// private:
		private function loadUrl():void{
			
			//if(SystemSettings.isOnline){			
				//_ldr.load(new URLRequest(_url), new LoaderContext(false,ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			//}else{
				_ldr.load(new URLRequest(_url));
			//}
			
		}
		
		private function loadReference():void{
			_reference.load();
			_reference.addEventListener (Event.COMPLETE, referenceLoaded, false, 0, true)
		}		

		// handlers:
		
		protected function loadingComplete(event:Event):void{
			
			//LoadingManager.getInstance().removeLoader();
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadingComplete)
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		protected function referenceLoaded(event:Event):void{
		
			_ldr.loadBytes(_reference.data); 
			
		}		
		// overrides:
		// getters and setters:

		public function get type():String{
			return _type;
		}

		public function get reference():FileReference{
			return _reference;
		}

		public function get url():String{
			return _url;
		}

		public function get image():Bitmap{
			return _ldr.content as Bitmap;
		}


	}
}