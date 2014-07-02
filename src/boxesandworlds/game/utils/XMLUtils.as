package boxesandworlds.game.utils 
{
	/**
	 * @author alexey
	 */
	public class XMLUtils 
	{
		static private var _list:Vector.<String>;
		
		public function XMLUtils() 
		{
		}
		
		static public function findNodesByType( xml:XML, nodeType:String ):Vector.<String> 
		{
			_list = new Vector.<String>();
			
			searching( xml, nodeType );
			
			return _list;
		}
		
		static private function searching( xml:XML, nodeType:String ):void
		{
			if (xml.@type == nodeType) {
				if (xml.@isArray == "true") {
					for each( var child:XML in xml.children() ) 
						_list.push(child);
				} else 
					_list.push(xml.@value);
			}
				
			for each( var it:XML in xml.children() )
				searching( it, nodeType );
		}
	}

}