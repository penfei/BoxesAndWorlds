package boxesandworlds.editor 
{
	import boxesandworlds.game.levels.Level;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jarkony
	 */
	public class TestScript
	{
		
		public function TestScript() 
		{
			
		}
		
		static public function layers():Vector.<Sprite> {
			var arr:Vector.<Sprite> = new Vector.<Sprite>();
			
			for (var i:uint = 0; i < 20; i++) {
				arr.push(new Sprite);
			}
			
			return arr;
		}
		
	}

}