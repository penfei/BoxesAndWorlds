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
				if ( data.player )
				{
					_game.objects.me.init( { start:new Vec2( 
								Game.WORLD_START_X_POSITION - 400.0 + ( uint(data.player.@worldId) - 1) * Game.WORLD_X_OFFSET + Number(data.player.@x),
								Game.WORLD_START_Y_POSITION - 400.0 + Number(data.player.@y)) } );
				}
				else
				{
					trace("player info not found in xml");
				}
				
				var i:uint = 0;
				var world:World;
				for each( var xmlWorld:XML in data.world )
				{
					var worldPosX:Number = Game.WORLD_START_X_POSITION + i * Game.WORLD_X_OFFSET;
					var worldPosY:Number = Game.WORLD_START_Y_POSITION;
						
					world = new World(_game);	
					world.init( { id:xmlWorld.@id, axis:new Vec2(worldPosX, worldPosY) } );
					_game.objects.worlds.push(world);
					
					if ( xmlWorld.@id == data.player.@worldId )
						world.addGameObject(_game.objects.me);
						
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
							
						if (object is WorldStructure) {
							params.start = Vec2.weak(world.data.axis.x - world.data.width / 2, world.data.axis.y - world.data.height / 2);
							object.init(params);
							world.addStructureToWorld(object as WorldStructure);
						} else {
							params.start = Vec2.weak(worldPosX + params.start.x, worldPosY + params.start.y); 
							object.init(params);
							world.addGameObject(object);
						}
					}
				}

				for each( world in _game.objects.worlds ) 
					world.postInit();
			}
		}		
	}

}