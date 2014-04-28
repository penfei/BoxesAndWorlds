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
		
		public static function offsetPoint(p:Point, dis:Number, ang:Number):Point 
		{
			var distance:Number = dis; 
			var angle:Number = 2 * Math.PI * (ang / 360); 
			return Point.polar(distance, angle); 
		}
		
		public static function arrangeClockwise(polygon:Polygon, pt0:Vec2, pt1:Vec2):Object
		{
			var obj:Object = new Object;
			var normal:Vec2 = new Vec2( -(pt1.y - pt0.y), pt1.x - pt0.x);
			var vertN:int = polygon.worldVerts.length;
			var i:int;
						
			function side(n:int):Boolean
			{
				return normal.dot(polygon.worldVerts.at(n).sub(pt0)) > 0;
			}
			for (i = 0; side(i) == true; i = (i + 1) % vertN) {}
			for (; side(i) == false; i = (i + 1) % vertN) {}
						
			var distPt0:Number = Math.abs(polygon.worldVerts.at(i).sub(pt0).dot(polygon.edges.at((i - 1 + vertN) % vertN).worldNormal));
			var distPt1:Number = Math.abs(polygon.worldVerts.at(i).sub(pt1).dot(polygon.edges.at((i - 1 + vertN) % vertN).worldNormal));
			var intersection0:Vec2;
			var intersection1:Vec2;
			if (distPt0 < distPt1)
			{
				intersection0 = pt0;
				intersection1 = pt1;
			} else{
				intersection0 = pt1;
				intersection1 = pt0;
			}
			for (var n:int = 0; n < 2; ++n)
			{
				var verts:Array = [n == 0 ? intersection0 : intersection1];
				for (; side(i) == (n == 0); i = (i + 1) % vertN)
				{
					verts.push(polygon.worldVerts.at(i));
				}
				verts.push(n == 0 ? intersection1 : intersection0);
				if (n == 0) obj.shape1 = verts;
				else obj.shape2 = verts;
			}
			return obj;
		}
		
		public static function arrangeClockwise2(vec:Array):Array
		{
			var n:int = vec.length, d:Number, i1:int = 1, i2:int = n-1;
			var tempVec:Array = new Array(n), C:Vec2, D:Vec2;

			vec.sort(comp1);			
			
			tempVec[0] = vec[0];
			C = vec[0];
			D = vec[n-1];
			
			for(var i:uint=1; i<n-1; i++)
			{
				d = det(C.x, C.y, D.x, D.y, vec[i].x, vec[i].y);
				if(d<0) tempVec[i1++] = vec[i];
				else tempVec[i2--] = vec[i];
			}
			
			tempVec[i1] = vec[n-1];
			
			return tempVec;
		}
		
		public static function comp1(a:Vec2, b:Vec2):Number
		{
			if(a.x>b.x) return 1;
			else if(a.x<b.x) return -1;
			
			return 0;
		}
		
		public static function det(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Number
		{
			return x1*y2+x2*y3+x3*y1-y1*x2-y2*x3-y3*x1;    
		}
		
		public static function getVelocityCount(speed:Number, angle:Number):Number {
			if (angle == 1) return angle * speed;
			return angle * speed * 0.7;
		}
		
		public static function lineIntersect(a1x:Number, a1y:Number, a2x:Number, a2y:Number, b1x:Number, b1y:Number, b2x:Number, b2y:Number):Object {
        
			var res:Object = new Object();
			res.intersect = -1;
			res.point = new Point();
			
			var d:Number = (a1x - a2x) * (b2y - b1y) - (a1y - a2y) * (b2x - b1x); 
			var da:Number = (a1x - b1x) * (b2y - b1y) - (a1y - b1y) * (b2x - b1x);
			var db:Number = (a1x - a2x) * (a1y - b1y) - (a1y - a2y) * (a1x - b1x);
			
			if (Math.abs(d) < 0.000001) {
				res.intersect = 0;
			} else {
				var ta:Number = da / d;
				var tb:Number = db / d;
				if ((0 <= ta) && (ta <= 1) && (0 <= tb) && (tb <= 1)) {
						res.intersect = 1;
						res.point.x = a1x + ta * (a2x - a1x);
						res.point.y = a1y + ta * (a2y - a1y);
				} 
				if (a2x > a1x && a2y < a1y) res.angle = Math.round(Math.atan(Math.abs(a2x - a1x) / Math.abs(a2y - a1y)) / Math.PI * 180);
				if (a2x > a1x && a2y > a1y) res.angle = Math.round(Math.atan(Math.abs(a2y - a1y) / Math.abs(a2x - a1x)) / Math.PI * 180) + 90;
				if (a2x < a1x && a2y > a1y) res.angle = Math.round(Math.atan(Math.abs(a2x - a1x) / Math.abs(a2y - a1y)) / Math.PI * 180) + 180;
				if (a2x < a1x && a2y < a1y) res.angle = Math.round(Math.atan(Math.abs(a2y - a1y) / Math.abs(a2x - a1x)) / Math.PI * 180) + 270;
			}
			
			return res;
			
		}
		
		static public function getRightPoints(points:Array):Array 
		{
			var p:Vector.<uint> = new Vector.<uint>;
			for (var i:uint = 0; i < points.length; i++) {
				var n:uint = i + 1;
				if (n == points.length) n = 0;
				if (points[i].x == points[n].x && points[i].y == points[n].y)
					p.push(i);
			}
			
			for (var j:int = p.length - 1; j >= 0; j--) {
				points.splice(p[j], 1);
				//TODO: Delete Next Line
				trace("o my god, i must be crashed, but my creator is so awesome, that i survived");
			}
			return points;
		}
		
		static public function getSwoopPoints(points:Array, position:Vec2, maxDistance:Number = 2300):Object
		{
			if (points.length < 2) return null;
			var returnPoints:Array = new Array;
			var distance:Number = maxDistance;
			var d:Number;
			returnPoints.push(points[0]);
			for (var i:uint = 1; i < points.length; i++) {
				d = Point.distance(points[i - 1], points[i])
				distance -= d;
				if (distance > 0) {
					returnPoints.push(points[i]);
				} else {
					distance += d;
					break;
				}
				
			}
			if (returnPoints.length < 2) return null;
			if (returnPoints[returnPoints.length - 1].y > returnPoints[0].y) returnPoints.reverse();
			returnPoints.push(returnPoints[0].clone());
			var offset:Point = new Point(position.x - returnPoints[0].x, position.y - returnPoints[0].y);
			for (i = 0; i < returnPoints.length; i++) {
				returnPoints[i].x += offset.x;
				returnPoints[i].y += offset.y;
			}
			return {points:returnPoints, distance:maxDistance - distance + Point.distance(returnPoints[returnPoints.length - 2], returnPoints[returnPoints.length - 1])};
		}

	}

}