package boxesandworlds.game.utils 
{
	import boxesandworlds.game.controller.PhysicsController;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	/**
	 * ...
	 * @author Sah
	 */
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			
		}
		
		public static function distance(a:Vec2, b:Vec2):Number {
			var p1:Point = new Point(a.x, a.y);
			var p2:Point = new Point(b.x, b.y);
			return Point.distance(p1, p2);
		}
		
		public static function diametr(points:Array):Number {
			var s:Number = 0;
			for (var i:uint = 0; i < points.length - 1; i++) {
				var p1:Point = new Point(points[i].x, points[i].y);
				var p2:Point = new Point(points[i + 1].x, points[i + 1].y);
				s += Point.distance(p1, p2);
			}
			s += Point.distance(p2, new Point(points[0].x, points[0].y));
			return s;
		}
		
		public static function square(points:Array):Number {
			var s:Number = 0;
			for (var i:uint = 0; i < points.length - 1; i++) {
				var p1:Point = new Point(points[i].x, points[i].y);
				var p2:Point = new Point(points[i + 1].x, points[i + 1].y);
				s += (p2.y + p1.y) / 2 * ((p2.x - p1.x));
			}
			var p3:Point = new Point(points[0].x, points[0].y);
			s += (p3.y + p2.y) / 2 * ((p3.x - p2.x) / 2);
			return s;
		}
		
		public static function getAngle(p1:Point, p2:Point):Number {
			var x1:Number = p1.x;
			var y1:Number = p1.y;
			var x2:Number = p2.x;
			var y2:Number = p2.y;
			var dis:Number = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
			var angle:Number = Math.round(Math.acos((x2 - x1) / dis) / Math.PI * 180);
			if (y2 > y1) return angle;
			else return 360 - angle;
		}
		
		public static function getAngle2(p1:Point, p2:Point):Number {
			var x1:Number = p1.x;
			var y1:Number = p1.y;
			var x2:Number = p2.x;
			var y2:Number = p2.y;
			var dis:Number = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
			var angle:Number = Math.round(Math.acos((x2 - x1) / dis) / Math.PI * 180);
			return angle;
		}
		
		public static function offsetPoint(p:Vec2, dis:Number, ang:Number):Vec2 
		{
			var angle:Number = 2 * Math.PI * (ang / 360); 
			return Vec2.fromPoint(Point.polar(dis, angle)); 
		}
		
		public static function det(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Number
		{
			return x1*y2+x2*y3+x3*y1-y1*x2-y2*x3-y3*x1;    
		}
		
		public static function getVelocityCount(speed:Number, angle:Number):Number {
			if (angle == 1) return angle * speed;
			return angle * speed * 0.7;
		}

	}

}