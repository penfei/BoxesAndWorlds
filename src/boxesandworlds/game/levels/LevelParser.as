package boxesandworlds.game.levels
{
	import boxesandworlds.game.objects.door.Door;
	import boxesandworlds.game.objects.enters.EnterData;
	import boxesandworlds.game.controller.Game;
	import boxesandworlds.game.objects.enters.edgeDoor.EdgeDoor;
	import boxesandworlds.game.objects.enters.gate.Gate;
	import boxesandworlds.game.objects.GameObject;
	import boxesandworlds.game.objects.items.box.Box;
	import boxesandworlds.game.objects.items.button.Button;
	import boxesandworlds.game.objects.items.key.Key;
	import boxesandworlds.game.objects.items.teleportBox.TeleportBox;
	import boxesandworlds.game.objects.items.worldBox.WorldBox;
	import boxesandworlds.game.objects.worldstructrure.WorldStructure;
	import boxesandworlds.game.world.World;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
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
			var xmlContent:Dictionary = _game.data.xmlLevelObjects;
			
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
					if (xmlWorld != null && xmlWorld.@id != null )
					{
						var worldPosX:Number = Game.WORLD_START_X_POSITION + i * Game.WORLD_X_OFFSET;
						var worldPosY:Number = Game.WORLD_START_Y_POSITION;
						
						world = new World(_game);	
						world.init( { id:xmlWorld.@id, axis:new Vec2(worldPosX, worldPosY) } );
					
						if ( xmlWorld.@id == data.player.@worldId )
							world.addGameObject(_game.objects.me);
						
						var worldStructureLoaded:Boolean = false;
						if ( xmlWorld.WorldStructure != null )
						{
							if ( xmlWorld.WorldStructure.physicsBitmapDataUrl != null )
							{
								var physPath:String = xmlWorld.WorldStructure.physicsBitmapDataUrl.@value;
								var bitmap:Bitmap = xmlContent[ physPath ];
								if ( bitmap != null )
								{
									var structure:WorldStructure = new WorldStructure(_game);
									structure.init( { physicsBitmapData:bitmap.bitmapData, 
										start:new Vec2(world.data.axis.x - world.data.width / 2, world.data.axis.y - world.data.height / 2) } );
									world.addStructureToWorld(structure);
									worldStructureLoaded = true;
								}
							}
						}
						
						if ( !worldStructureLoaded )
						{
							trace( "WorldStructure not found in world " + xmlWorld.@id );
							continue;
						}
						++i;
						_game.objects.worlds.push( world );	
						
						var it:XML;
						for each( it in xmlWorld.Box )
						{
							var box:Box = new Box(_game);
							box.init( { start:new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) )});
							world.addGameObject(box);
						}
						
						for each( it in xmlWorld.TeleportBox )
						{
							var teleportBox:TeleportBox = new TeleportBox(_game);
							teleportBox.init( { start:new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) ),
										teleportId:int(it.teleportId.@value), id: int(it.id.@value) } );
							world.addGameObject(teleportBox);
						}
						
						for each( it in xmlWorld.WorldBox )
						{
							var worldBox:WorldBox = new WorldBox (_game);
							worldBox.init( { start:new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) ),
										childWorldId:int(it.teleportId.@value) } );
							world.addGameObject(worldBox);
						}

						var params:Object = { };
						for each( it in xmlWorld.EdgeDoor )
						{
							var edgeDoor:EdgeDoor = new EdgeDoor(_game);
							params = { };
							params.start = new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) );
							
							if ( it.hasOwnProperty("edge") )
								params.edge = it.edge.@value;
							else
								params.edge = EnterData.LEFT;
								
							if ( it.hasOwnProperty("width") )
								params.width = Number(it.width.@value);
							if ( it.hasOwnProperty("height") )
								params.height = Number(it.height.@value);
								
							edgeDoor.init( params );
							world.addGameObject( edgeDoor );
						}

						for each( it in xmlWorld.Gate )
						{
							var gate:Gate = new Gate(_game);
							params = { };
							params.start = new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) );
							
							if ( it.hasOwnProperty("edge") )
								params.edge = it.edge.@value;
							else
								params.edge = EnterData.LEFT;
							
							if ( it.hasOwnProperty("width") )
								params.width = Number(it.width.@value);
							if ( it.hasOwnProperty("height") )
								params.height = Number(it.height.@value);
							
							gate.init( params );
							world.addGameObject( gate );
						}
						
						for each( it in xmlWorld.Door )
						{
							var door:Door = new Door(_game);
							door.init( { start:new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) ),
										id:int(it.id.@value) } );
							world.addGameObject(door);
						}
						
						for each( it in xmlWorld.Key )
						{
							var key:Key = new Key(_game);
							key.init( { start:new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) ),
										openedId:int(it.openedId.@value) } );
							world.addGameObject(key);
						}
						
						for each( it in xmlWorld.Button )
						{
							var button:Button = new Button(_game);
							button.init( { start:new Vec2(worldPosX + Number(it.start.@x), worldPosY + Number(it.start.@y) ),
										openedId:int(it.openedId.@value) } );
							world.addGameObject(button);
						}
					}
				}
				for each( world in _game.objects.worlds ) 
					world.postInit();
			}
		}
		
		private function createButton(mc:DisplayObject, name:String):void 
		{
			var start:Vec2 = new Vec2(mc.x, mc.y);
			var params:Object = { type:name.split("_")[0], id:Number(name.split("_")[1]), ui:mc, bodyType:BodyType.STATIC, start:start };
			var obj:Button = new Button(_game);
			add(obj, params);
		}
		
		private function add(obj:GameObject, params:Object):void {
			_parsedObjects.push({obj:obj, params:params});
		}		
	}

}