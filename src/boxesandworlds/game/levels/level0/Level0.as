package boxesandworlds.game.levels.level0
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.objects.items.button.Button;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	/**
	 * @author Alexey
	 */
	public class Level0 extends Level
	{
		[Embed(source='../../../../../assets/levels/0/Level0.xml',
			mimeType="application/octet-stream")]
		public static const LevelDataClass:Class; 
		
		public function Level0(game:Game):void
		{
			super(game);
		}
		
		override public function init():void {
			super.init();
				
			setByXML( new XML( new LevelDataClass ) );			
			game.physics.world.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, game.physics.buttonType, game.physics.movableType, buttonContactHandler));
		}
		
		override public function start():void 
		{
			
		}
		
		override public function destroy():void {
			
		}
		
		override public function gameOver():void 
		{
			
		}
		
		override public function step():void 
		{
			
		}
		
		private function buttonContactHandler(e:InteractionCallback):void 
		{
			var button:Button = e.int1.userData.obj as Button;
			
		}		
	}

}