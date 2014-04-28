package boxesandworlds.data 
{
	/**
	 * ...
	 * @author Sah
	 */
	public class BawUser 
	{
		private var _name:String;
		private var _id:String;
		
		public function BawUser(id:String) 
		{
			_id = id;
		}
		
		public function get id():String {return _id;}
		public function get name():String {return _name;}
		public function set name(value:String):void {_name = value;}
		
	}

}