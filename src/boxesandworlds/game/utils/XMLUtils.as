package boxesandworlds.game.utils 
{
	/**
	 * @author alexey
	 */
	public class XMLUtils 
	{
		static private var _nodesList:XMLList;
		
		public function XMLUtils() 
		{
		}
		
		static public function findNodesByName( xml:XML, nodeName:String ):XMLList 
		{
			_nodesList = new XMLList();
			
			searching( xml, nodeName );
			
			return _nodesList;
		}
		
		static private function searching( xml:XML, nodeName:String ):void
		{
			if (xml.name() == nodeName)
				_nodesList += xml;
				
			for each( var it:XML in xml.children() )
				searching( it, nodeName );
		}
	}

}