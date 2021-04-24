package;

import actors.Actor;
import actors.Player;
import data.Levels;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import objects.Item;

typedef LevelItem = {
    var pos:ItemPos;
    var floorType:FloorType;
    var player:Null<Player>;
    // var monster:Null<Monster>;
    var item:Null<Item>;
    var thrownItem:Null<Item>;
}

// Needed?
typedef ItemPos = {
    var x:Int;
    var y:Int;
}


class PlayState extends FlxState {
    static inline final TILE_SIZE = 16;

    var items:Array<Item>;
    var gameData:Array<Array<LevelItem>>;

    var player:Player;

    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;

        var playerPos:ItemPos = { x: 2, y: 2 };

        // REMOVE: get from game data later
        var torchPos:ItemPos = { x: 5, y: 2 };

        player = new Player(0, 0, playerPos, this);

        var tileArray = [];
        gameData = [];
        items = [];
        for (y in 0...Levels.data.length) {
            var row = [];
            for (x in 0...Levels.data[y].length) {
                tileArray.push(Levels.data[y][x].item);

                var floorType = Wall;
                if (Levels.data[y][x].item == 6) {
                    floorType = Floor;
                }

                var item = {
                    pos: { x: x, y: y },
                    floorType: floorType,
                    player: null,
                    item: null,
                    thrownItem: null
                };

                if (x == playerPos.x && y == playerPos.y) {
                    item.player = player;
                }

                if (x == torchPos.x && y == torchPos.y) {
                    var torch = new Item(0, 0, Torch, torchPos);
                    items.push(torch);
                    item.item = torch;
                }

                row.push(item);
            }

            gameData.push(row);
        }

        createTilemap(tileArray);

        add(player);
        for (item in items) add(item);
    }

    override public function update(elapsed:Float) {
        updateGameData();

        super.update(elapsed);
    }

    // LATER: around turning around in a square?
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
            }

            if (FlxG.keys.pressed.RIGHT) {
                var checked = checkItem({ x: player.pos.x + 1, y: player.pos.y });

                if (checked != null) {
                    toItem = checked;
                }
            }

            if (FlxG.keys.pressed.UP) {
                var checked = checkItem({ x: player.pos.x, y: player.pos.y - 1 });

                if (checked != null) {
                    toItem = checked;
                }
            }

            if (FlxG.keys.pressed.DOWN) {
                var checked = checkItem({ x: player.pos.x, y: player.pos.y + 1 });

                if (checked != null) {
                    toItem = checked;
                }
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
        if (FlxG.keys.anyJustPressed([TAB, X])) {
            var atItem = getItem(player.pos.x, player.pos.y);

            // switch the items out, temporarily held by nothing
            if (atItem.item != null) {
                var tempItem = atItem.item;
                atItem.item = null;

                player.pickUp(tempItem);
            }
        }

        // check thrown, etc.
        for (item in items) {
            item.check();
        }
    }

    public function playerDrop (item:Item, pos:ItemPos) {
        var floorItem:LevelItem = getItem(pos.x, pos.y);

        // switch the items out, temporarily held by nothing
        if (floorItem.item != null) {
            var tempItem = floorItem.item;

            // break one of the two
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

    function getItem (x:Int, y:Int):LevelItem {
        return gameData[y][x];
    }

    function createTilemap (tileArray:Array<Int>) {
        var tileMap = new FlxTilemap();
        tileMap.loadMapFromArray(tileArray, 15, 10, AssetPaths.tiles__png, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 1, 1, 1);
        tileMap.useScaleHack = false;
        add(tileMap);
    }
}
