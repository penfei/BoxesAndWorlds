package boxesandworlds.game.levels
{
	import boxesandworlds.controller.Core;
	import boxesandworlds.data.ObjectsLibrary;
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.data.Attribute;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.worldstructrure.WorldStructure;
	import boxesandworlds.game.utils.ContentUtils;
	import boxesandworlds.game.world.World;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author Sah
	 */
	public class LevelParser 
	{
		private var _game:Game;
		private var _parsedObjects:Vector.<Object>;
		private var _isParsed:Boolean;
		
		public function LevelParser(game:Game) 
		{
			_isParsed = false;
			_game = game;
		}
		
		
		public function parse():void {
			//return;
			var data:XML = _game.data.xmlLevelParams;
			var content:Object = Core.content.library;
			
			if (!_isParsed && data) 
			{				
				var world:World;
				var worldPosX:Number = 0;
				for each( var xmlWorld:XML in data.world )
				{
					world = new World(_game);	
					world.init( { id:xmlWorld.@id, axis:new Vec2(worldPosX, 0), physic:xmlWorld } );
					_game.objects.worlds.push(world);
					worldPosX += world.data.width + 200;
						
					for each( var child:XML in xmlWorld.children() )
					{
						var objectClass:Class = ObjectsLibrary.getObjectClassByType(child.name());
						var object:GameObject = new objectClass(_game);
						var params:Object = {start: new Vec2};
						for each( var par:XML in child.children() ) {
							if (par.@isArray == "true") {
								var arr:Array = [];
								for each( var parChild:XML in par.children() ) {
									if (par.@type == Attribute.VEC2) arr.push(Vec2.weak(parChild.valueX, parChild.valueY));
									else if (par.@type == Attribute.URL) arr.push(ContentUtils.copy(content[String(parChild)]));
									else arr.push(parChild);
								}
								params[par.name()] = arr;
							} else {
								if (par.@type == Attribute.VEC2) params[par.name()] = Vec2.weak(par.@x, par.@y);
								else if (par.@type == Attribute.URL) params[par.name()] = ContentUtils.copy(content[String(par.@value)]);
								else params[par.name()] = par.@value;
							}
						}
						params.start = Vec2.weak(world.data.axis.x + params.start.x, world.data.axis.y + params.start.y); 
						object.init(params);
						object.addToWorld(world);
					}
				}
				
				if (data.player )
				{
					world = _game.objects.getWorldById(data.player.@worldId);
					_game.objects.me.init( { start:Vec2.weak(world.data.axis.x + Number(data.player.@x), world.data.axis.y + Number(data.player.@y)) } );
					_game.objects.me.addToWorld(world);
				}
				else
				{
					trace("player info not found in xml");
				}

				for each( world in _game.objects.worlds ) 
					world.postInit();
			}
		}		
	}

}