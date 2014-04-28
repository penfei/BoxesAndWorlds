package boxesandworlds.game.levels 
{
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class LevelData 
	{
		private var _startHeroPostion:Vec2;
		private var _url:String;
		
		public function LevelData() 
		{
			
		}
		
		public function get startHeroPostion():Vec2 {return _startHeroPostion;}
		public function set startHeroPostion(value:Vec2):void {_startHeroPostion = value;}
		public function get url():String {return _url;}
		public function set url(value:String):void {_url = value;}
		
	}

}