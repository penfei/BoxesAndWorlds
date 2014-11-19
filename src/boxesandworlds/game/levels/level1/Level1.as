package boxesandworlds.game.levels.level1
{
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.levels.Level;
	import boxesandworlds.game.objects.activator.ActivatorObject;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	/**
	 * @author Sah
	 */
	public class Level1 extends Level
	{		
		public function Level1(game:Game):void
		{
			super(game);
		}
		
		static public function layers():Vector.<Sprite> {
			var arr:Vector.<Sprite> = Level.layers();
			//var glow:GlowFilter = new GlowFilter(0xC1E1C4, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, false);
			//var glow2:GlowFilter = new GlowFilter(0xC1E1C4, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, true);
			//var glow3:GlowFilter = new GlowFilter(0x993300, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, false);
			
			var glow:GlowFilter = new GlowFilter(0x0099CC, 1, 2, 2, 10, BitmapFilterQuality.HIGH, false, false);
			
			var blur:BlurFilter = new BlurFilter(0, 56, 3);
			var blur2:BlurFilter = new BlurFilter(0, 14);
			var blur3:BlurFilter = new BlurFilter(0, 3, 3);
			
			arr[1].z = 500;
			//arr[5].filters = [glow3, blur3];
			//arr[6].filters = [glow3, blur3];
			//arr[8].filters = [glow, blur2];
			//arr[9].filters = [glow2, blur2];
			//arr[10].filters = [glow];
			//arr[11].filters = [glow, blur2];
			//arr[12].filters = [glow2, blur2];
			//arr[13].filters = [glow2, blur2];
			//arr[14].filters = [glow, blur2];
			//arr[15].filters = [glow2, blur2];
			//arr[16].filters = [glow, blur2];
			//arr[17].filters = [glow, blur2];
			//arr[18].filters = [glow, blur2];
			//
			//arr[25].filters = [glow3, blur3];
			//arr[26].filters = [glow3, blur3];
			//arr[27].filters = [glow3, blur3];
			
			return arr;
		}
		
		override public function getLayers():Vector.<Sprite> {
			return layers();
		}
		
		override public function init():void {
			super.init();
			
			game.gui.offsetY = 0.3;
			//TweenMax.to(game.objects.me.playerView.ui, 0, { colorTransform: { tint:0x3366CC, tintAmount:1 }} );
			TweenMax.to(game.objects.me.playerView.ui, 0, { colorTransform: { tint:0, tintAmount:1 }} );
			
			for (var i:uint = 3; i < 27; i++) {
				for (var j:uint = 0; j < game.objects.getObjectById(i).data.views.length; j++) {
					if (i < 13) {
						if(j == 1) TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0xB33A00, tintAmount:1 }} );
						else if(j == 2) TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0xCE4300, tintAmount:1 }} );
						else TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0x993300, tintAmount:1 }} );
					}
					else if(i < 20 || i >= 25){
						if(j == 1) TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0x277827, tintAmount:1 }} ); 
						else if(j == 2) TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0x216721, tintAmount:1 }} );
						else if(j == 3) TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0x1E5B1E, tintAmount:1 }} );
						else if(j == 4) TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0x7DD57D, tintAmount:1 }} );
						else TweenMax.to( game.objects.getObjectById(i).data.views[j], 0, { colorTransform: { tint:0x003300, tintAmount:1 }} );
					}
				}
			}
			
			(game.objects.getObjectById(23) as ActivatorObject).activatorData.callBack = needleCallBack;
			jointWorldWithBody(game.objects.getObjectById(13).body, 90, -330, 90, -330);
			jointBodyWithJumper(game.objects.getObjectById(13).body, game.objects.getObjectById(3).body);
			
			jointWorldWithBody(game.objects.getObjectById(14).body, 320, -330, 320, -330);
			jointBodyWithJumper(game.objects.getObjectById(14).body, game.objects.getObjectById(4).body);
			jointBodyWithJumper(game.objects.getObjectById(14).body, game.objects.getObjectById(5).body);
			jointBodyWithJumper(game.objects.getObjectById(14).body, game.objects.getObjectById(6).body);
			
			jointWorldWithBody(game.objects.getObjectById(15).body, 120, -330, 120, -330);
			
			jointWorldWithBody(game.objects.getObjectById(17).body, 300, -330, 300, -330);
			jointBodyWithJumper(game.objects.getObjectById(17).body, game.objects.getObjectById(7).body);
			jointBodyWithJumper(game.objects.getObjectById(17).body, game.objects.getObjectById(10).body);
			
			jointWorldWithBody(game.objects.getObjectById(18).body, 200, -330, 200, -330);
			jointBodyWithJumper(game.objects.getObjectById(18).body, game.objects.getObjectById(9).body);
			jointBodyWithJumper(game.objects.getObjectById(18).body, game.objects.getObjectById(12).body);
			
			jointWorldWithBody(game.objects.getObjectById(19).body, 150, -330, 150, -330);
			jointBodyWithJumper(game.objects.getObjectById(19).body, game.objects.getObjectById(11).body);
			
			//game.stage.addEventListener(MouseEvent.CLICK, test);
		}
		
		private function test(e:MouseEvent):void 
		{
			
			var shadow:MovieClip = game.objects.getWorldById(2).structure.data.views[3];
			if (shadow.currentFrame == 1) {
				if (shadow.light.currentFrame == 1) {
					shadow.light.gotoAndStop(2);
				}
				else {
					shadow.gotoAndStop(2);
				}
			} else {
				shadow.gotoAndStop(1);
				shadow.light.gotoAndStop(1);
			}
		}
		
		private function jointWorldWithBody(body:Body, worldX:Number, worldY:Number, bodyX:Number, bodyY:Number):void {
			var p:Vec2 = body.position.copy();
			p.x += worldX;
			p.y += worldY;
			var joint:PivotJoint = new PivotJoint(game.physics.world.world, body, p, Vec2.weak(bodyX, bodyY));
			joint.space = game.physics.world;
			joint.damping = 2;
			joint.stiff = false;
		}
		
		private function jointBodyWithJumper(body:Body, jumper:Body):void {
			for (var i:int = 0; i < jumper.shapes.length; i++) {
				jumper.shapes.at(i).filter.collisionGroup = 0x10000;
			}
			for (i = 0; i < body.shapes.length; i++) {
				body.shapes.at(i).filter.collisionMask = ~0x10000;
			}
			var joint:WeldJoint = new WeldJoint(jumper, body,  body.localPointToWorld(Vec2.weak()), jumper.localPointToWorld(Vec2.weak()));
			joint.space = game.physics.world;
			joint.ignore = true;
		}
		
		private function needleCallBack(needle:ActivatorObject):void {
			if (!needle.activatorData.isActivate) {
				needle.activatorData.isActivate = true;
				
				for (var i:uint = 0; i < needle.body.shapes.length; i++) {
					needle.body.shapes.at(i).filter.collisionMask = 0;
				}
				
				needle.data.views[0].gotoAndPlay(2);
			}
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
	}

}