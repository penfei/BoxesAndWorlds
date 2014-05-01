package boxesandworlds.game.objects.worldstructrure 
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.GameObject;
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.MarchingSquares;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	/**
	 * ...
	 * @author Sah
	 */
	public class WorldStructure extends GameObject
	{
		private var _view:WorldStructureView;
		private var _properties:WorldStructureData;
		
		public function WorldStructure(game:Game) 
		{
			super(game);
		}
		
		public function get structureData():WorldStructureData {return _properties;}
		public function set structureData(value:WorldStructureData):void {_properties = value;}
		public function get structureView():WorldStructureView {return _view;}
		public function set structureView(value:WorldStructureView):void { _view = value; }
		
		override public function init(params:Object = null):void {
			data = new WorldStructureData(game);
			_properties = data as WorldStructureData;
			data.init(params);
			
			_view = new WorldStructureView(game, this);
			view = _view;
			super.init();
		}
		
		override protected function initPhysics():void {
			var iso:BitmapDataIso = new BitmapDataIso(_properties.physicsBitmapData, 0x80);
			
			body = new Body(_properties.bodyType, _properties.startPosition);
			
			var polys:GeomPolyList = MarchingSquares.run(iso, iso.bounds, _properties.granularity, _properties.quality);
			for (var i:int = 0; i < polys.length; i++) {
				var p:GeomPoly = polys.at(i);

				var qolys:GeomPolyList = p.simplify(_properties.simplification).convexDecomposition(true);
				for (var j:int = 0; j < qolys.length; j++) {
					var q:GeomPoly = qolys.at(j);
					body.shapes.add(new Polygon(q));
					q.dispose();
				}
				qolys.clear();
				p.dispose();
			}
			polys.clear();

			var pivot:Vec2 = body.localCOM.mul(-1);
			body.translateShapes(pivot);
			body.userData.graphicOffset = pivot;
			
			body.space = game.physics.world;
			_properties.mass = body.mass;
		}
		
	}

}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import nape.geom.AABB;
import nape.geom.IsoFunction;

class BitmapDataIso implements IsoFunction {
    public var bitmap:BitmapData;
    public var alphaThreshold:Number;
    public var bounds:AABB;

    public function BitmapDataIso(bitmap:BitmapData, alphaThreshold:Number = 0x80):void {
        this.bitmap = bitmap;
        this.alphaThreshold = alphaThreshold;
        bounds = new AABB(0, 0, bitmap.width, bitmap.height);
    }

    public function graphic():DisplayObject {
        return new Bitmap(bitmap);
    }

    public function iso(x:Number, y:Number):Number {
        var ix:int = int(x); var iy:int = int(y);
        if(ix<0) ix = 0; if(iy<0) iy = 0;
        if(ix>=bitmap.width)  ix = bitmap.width-1;
        if(iy>=bitmap.height) iy = bitmap.height-1;

        var a11:Number = alphaThreshold - (bitmap.getPixel32(ix,iy)>>>24);
        var a12:Number = alphaThreshold - (bitmap.getPixel32(ix+1,iy)>>>24);
        var a21:Number = alphaThreshold - (bitmap.getPixel32(ix,iy+1)>>>24);
        var a22:Number = alphaThreshold - (bitmap.getPixel32(ix+1,iy+1)>>>24);

        var fx:Number = x - ix; var fy:Number = y - iy;
        return a11*(1-fx)*(1-fy) + a12*fx*(1-fy) + a21*(1-fx)*fy + a22*fx*fy;
    }
}
