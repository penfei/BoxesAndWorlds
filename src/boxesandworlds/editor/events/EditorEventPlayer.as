package boxesandworlds.editor.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jarkony
	 */
	public class EditorEventPlayer extends Event {
		
		// const
		static public const PLAYER_NOT_SETUP:String = "editorEventPlayerNotSetup";
		
		public function EditorEventPlayer(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}

}