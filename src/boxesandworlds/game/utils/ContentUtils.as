package boxesandworlds.game.utils 
{
	import flash.display.Bitmap;
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
			else return content;
		}
		
		static public function copyBitmap(content:Bitmap):Bitmap {
			return new Bitmap(content.bitmapData);
		}
		
	}

}