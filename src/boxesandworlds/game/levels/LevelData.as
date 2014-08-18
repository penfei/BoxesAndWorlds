package boxesandworlds.game.levels 
{
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class LevelData 
	{
		private var _name:String;
		
		public function LevelData() 
		{
			
		}
		
		public function get name():String {return _name;}
		public function set name(value:String):void {_name = value;}
		
	}

}