package boxesandworlds.gui 
{
	import flash.events.Event;	
	
	/**
	 * ...
	 * @author Sah
	 */
	public class ViewEvent extends Event
	{
		static public const SHOW_ANIMATION_COMPLETE:String = "showAnimationComplete";
		static public const HIDE_ANIMATION_COMPLETE:String = "hideAnimationComplete";
		static public const LOAD_COMPLETE:String = "loadComplete";
				
		public function ViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles,cancelable)
		}
				
		override public function toString():String 
		{
			return "[ViewEvent]";
		}
		
		override public function clone():flash.events.Event 
		{
			return new ViewEvent(type, bubbles, cancelable);
		}
		
	}

}