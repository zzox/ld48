package;

import openfl.display.Tilemap;
import Utils;
import actors.Player;
import data.Levels;
import display.Lighting;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.util.FlxSort;
import flixel.util.FlxColor;
import objects.DItem;
import objects.Item;
import objects.Light;
import objects.TorchSet;

typedef LevelItem = {
    var pos:ItemPos;
    var floorType:FloorType;
    var player:Null<Player>;
    // var monster:Null<Monster>;
    var item:Null<Item>;
    var thrownItem:Null<Item>;
    var torchSet:Null<TorchSet>;
}

// Needed?
typedef ItemPos = {
    var x:Int;
    var y:Int;
}

enum FloorType {
    Wall;
    Floor;
}

class PlayState extends FlxState {
    static inline final TILE_SIZE = 16; // also used for light diff distance
    static inline final LEVEL_WIDTH = 15; // width in tiles
    static inline final LEVEL_HEIGHT = 10; // width in tiles

    var items:Array<Item>;
    var gameData:Array<Array<LevelItem>>;

    var displayGroup:FlxTypedGroup<DItem>;

    var player:Player;

    public var lighting:Lighting;

    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;

        // TEMP: get from game singleton later
        var level = 0;
        var levelData = Levels.data[level];

        var map = new TiledMap(levelData.path);
        var layerData = map.getLayer('floor');
        var tileArray:Array<Int> = cast(layerData, TiledTileLayer).tileArray;
        createTilemap(tileArray);

        var torchSets = [];
        gameData = [];
        items = [];
        for (y in 0...LEVEL_HEIGHT) {
            var row = [];
            for (x in 0...LEVEL_WIDTH) {
                var thisPos:ItemPos = { x: x, y: y };

                var floorType = Wall;
                if (tileArray[y * LEVEL_WIDTH + x] == 6) {
                    floorType = Floor;
                }

                var item = {
                    pos: thisPos,
                    floorType: floorType,
                    player: null,
                    item: null,
                    thrownItem: null,
                    torchSet: null
                };

                row.push(item);
            }

            gameData.push(row);
        }

        player = new Player(0, 0, levelData.start, this);

        var startItem = getItem(levelData.start.x, levelData.start.y);
        startItem.player = player;

        displayGroup = new FlxTypedGroup<DItem>();
        displayGroup.add(player);

        for (torchItem in levelData.torches) {
            var torch = new Item(0, 0, Torch, torchItem);

            var torchFloorItem = getItem(torchItem.x, torchItem.y);
            items.push(torch);
            torchFloorItem.item = torch;
            displayGroup.add(torch);

            if (Math.random() < levelData.litChance) {
                torch.ignite();
            }
        }

        for (torchSetItem in levelData.torchSets) {
            var torchSetPos:FlxPoint = Utils.translatePos(torchSetItem); // change name
            var torchSet = new TorchSet(
                torchSetPos.x,
                torchSetPos.y,
                torchSetItem,
                this,
                Math.random() < levelData.setLitChance
            );

            var torchSetFloorItem = getItem(torchSetItem.x, torchSetItem.y);
            torchSetFloorItem.torchSet = torchSet;

            torchSets.push(torchSet);
        }

        add(displayGroup);

        lighting = new Lighting();
        lighting.color = FlxColor.BLACK;

        for (torch in torchSets) {
            torch.addItems(
                checkItem({ x: torch.pos.x - 1, y: torch.pos.y }) == null,
                checkItem({ x: torch.pos.x + 1, y: torch.pos.y }) == null,
                checkItem({ x: torch.pos.x, y: torch.pos.y - 1 }) == null,
                checkItem({ x: torch.pos.x, y: torch.pos.y + 1 }) == null
            );

            add(torch);
        }

        add(lighting);

        var holeLightPos = Utils.translatePos(levelData.start);
        var holeLight = new Light(holeLightPos.x - TILE_SIZE, holeLightPos.y - TILE_SIZE, Circle);

        lighting.add(holeLight);
        for (item in items) {
            if (item.type == Torch) {
                lighting.add(item.light);
            }
        }
    }

    override public function update(elapsed:Float) {
        updateGameData();

        displayGroup.sort((order:Int, obj1:DItem, obj2:DItem) ->
            FlxSort.byValues(order, obj1.depth, obj2.depth)
        );

        super.update(elapsed);
    }

    function updateGameData () {
        var toItem:Null<LevelItem> = null;

        // TODO: buffer/recentcy system
        // only assign if we can go, solving for multiple presses when rounding corners
        if (!player.moving) {
            if (FlxG.keys.pressed.LEFT) {
                var checked = checkItem({ x: player.pos.x - 1, y: player.pos.y });

                if (checked != null) {
                    toItem = checked;
                }

                player.isFacing = Left;
            }

            if (FlxG.keys.pressed.RIGHT) {
                var checked = checkItem({ x: player.pos.x + 1, y: player.pos.y });

                if (checked != null) {
                    toItem = checked;
                }

                player.isFacing = Right;
            }

            if (FlxG.keys.pressed.UP) {
                var checked = checkItem({ x: player.pos.x, y: player.pos.y - 1 });

                if (checked != null) {
                    toItem = checked;
                }

                player.isFacing = Up;
            }

            if (FlxG.keys.pressed.DOWN) {
                var checked = checkItem({ x: player.pos.x, y: player.pos.y + 1 });

                if (checked != null) {
                    toItem = checked;
                }

                player.isFacing = Down;
            }

            if (player.held != null && player.held.type == Torch && toItem != null && toItem.torchSet != null) {
                lightIfPossible(player.held, toItem.torchSet);
            }
        }

        // if player can move AND has pressed a direction
        if (toItem != null) {
            if (toItem.floorType == Floor) {
                player.move(toItem.pos);
            } else {
                // already checked, but we can play sound here
            }
        }

        // pick up logic
        if (FlxG.keys.anyJustPressed([SPACE, X])) {
            var thrown:Bool = false;

            if (player.held != null) {
                var heldItem = player.held;
                heldItem.throwMe(player.pos, player.isFacing);
                var levelItem = getItem(player.pos.x, player.pos.y);
                levelItem.thrownItem = heldItem;

                player.held = null;

                thrown = true;
            }

            // if we didn't throw something, we can try picking up something
            if (!thrown) {
                var atItem = getItem(player.pos.x, player.pos.y);
                // switch the items out, temporarily held by nothing
                if (atItem.item != null) {
                    var tempItem = atItem.item;
                    atItem.item = null;

                    player.pickUp(tempItem);
                } else {
                    // play miss sound
                }
            }
        }

        // check thrown, etc.
        for (item in items) {
            if (!item.moving && item.thrown != null) {
                var toItem = getItemFromDir(item.pos, item.thrown);

                if (item.type == Torch && toItem.torchSet != null) {
                    lightIfPossible(item, toItem.torchSet);
                }

                if (toItem.floorType == Wall) {
                    drop(item, item.pos);
                } else {
                    item.throwMe(toItem.pos, item.thrown);
                }
            }
        }
    }

    function lightIfPossible (item:Item, torchSet:TorchSet) {
        if (item.lit && !torchSet.lit) {
            torchSet.light();
        }

        if (!item.lit && torchSet.lit) {
            item.ignite();
        }
    }

    public function drop (item:Item, pos:ItemPos) {
        item.held = false;
        item.thrown = null;

        var floorItem:LevelItem = getItem(pos.x, pos.y);

        // switch the items out, temporarily held by nothing
        if (floorItem.item != null) {
            var tempItem = floorItem.item;


            // break one of the two
            // if the floor item is a rock, kill the thrown item
                // otherwise, kill the floor item

        }

        floorItem.item = item;
    }

    function checkItem (pos:ItemPos):Null<LevelItem> {
        var item:LevelItem = getItem(pos.x, pos.y);
        if (item.floorType == Floor) {
            return item;
        }

        return null;
    }

    function getItemFromDir (pos:ItemPos, dir:Dir):LevelItem {
        var x = pos.x;
        var y = pos.y;

        switch (dir) {
            case Left: x--;
            case Right: x++;
            case Up: y--;
            case Down: y++;
        }

        return getItem(x, y);
    }

    function getItem (x:Int, y:Int):LevelItem {
        return gameData[y][x];
    }

    function createTilemap (tileArray:Array<Int>) {
        var tileMap = new FlxTilemap();
        tileMap.loadMapFromArray(tileArray, 15, 10, AssetPaths.tiles__png, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 1, 1, 1);
        tileMap.useScaleHack = false;
        add(tileMap);
    }

    function addLight (light:Light) {
        lighting.add(light);
    }
}
