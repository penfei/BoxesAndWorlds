package boxesandworlds.game.utils 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Sah
	 */
	public class ContentUtils 
	{
		
		public function ContentUtils() 
		{
			
		}
		
		static public function copy(content:*):*{
			if (content is Bitmap) return copyBitmap(content as Bitmap);
			if (content is MovieClip) return copySWF(content as MovieClip);
			else return content;
		}
		
		static public function copyBitmap(content:Bitmap):Bitmap {
			return new Bitmap(content.bitmapData);
		}
		
		static public function copySWF(content:MovieClip):MovieClip {
			return new content.constructor;
		}
		
	}

}