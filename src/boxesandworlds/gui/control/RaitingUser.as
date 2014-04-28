package boxesandworlds.gui.control 
{
	import boxesandworlds.data.CUser;
	import flash.display.Sprite;
	import symbols.view.RaitingUserUI;
	/**
	 * ...
	 * @author Sah
	 */
	public class RaitingUser extends Sprite
	{
		private var _ui:RaitingUserUI
		private var _id:uint;
		private var _user:CUser;
		
		public function RaitingUser(id:uint, user:CUser) 
		{
			_user = user;
			_id = id;
			_ui = new RaitingUserUI;
			_ui.user.text = user.name;
			_ui.place.text = String(user.raitingPosition + 1);
			_ui.points.text = user.bestPoints.toString();
			if (id % 2) _ui.back.visible = false;
			addChild(_ui);
		}
		
	}

}