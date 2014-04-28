package boxesandworlds.game.utils 
{
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author ...
	 */
	public class KeyboardUtils 
	{
		
		public function KeyboardUtils() 
		{
			
		}
		
		public static function getNameKey(keyCode:Number):String {
			switch (keyCode) 
			{
				case Keyboard.Q:
					return "Q";
				case Keyboard.W:
					return "W";
				case Keyboard.E:
					return "E";
				case Keyboard.R:
					return "R";
				case Keyboard.T:
					return "T";
				case Keyboard.Y:
					return "Y";
				case Keyboard.U:
					return "U";
				case Keyboard.I:
					return "I";
				case Keyboard.O:
					return "O";
				case Keyboard.P:
					return "P";
				case Keyboard.A:
					return "A";
				case Keyboard.S:
					return "S";
				case Keyboard.D:
					return "D";
				case Keyboard.F:
					return "F";
				case Keyboard.G:
					return "G";
				case Keyboard.H:
					return "H";
				case Keyboard.J:
					return "J";
				case Keyboard.K:
					return "K";
				case Keyboard.L:
					return "L";
				case Keyboard.Z:
					return "Z";
				case Keyboard.X:
					return "X";
				case Keyboard.C:
					return "C";
				case Keyboard.V:
					return "V";
				case Keyboard.B:
					return "B";
				case Keyboard.N:
					return "N";
				case Keyboard.M:
					return "M";
				case Keyboard.SPACE:
					return "SPACE";
				default:
					return "";
			}
		}
		
	}

}