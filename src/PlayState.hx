package;

import actors.Actor;
import actors.Player;
import data.Levels;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;

typedef LevelItem = {
    var pos:ItemPos;
    var floorType:FloorType;
    var player:Null<Player>;
    // var monster:Null<Monster>;
    // var item:Null<Item>;
}

// Needed?
typedef ItemPos = {
    var x:Int;
    var y:Int;
}


class PlayState extends FlxState {
    static inline final TILE_SIZE = 16;

    var gameData:Array<Array<LevelItem>>;

    var player:Player;

    override public function create() {
        super.create();

        // camera.pixelPerfectRender = true;
        var playerPos:ItemPos = { x: 2, y: 2 };
        player = new Player(0, 0, playerPos, this);

        var tileArray = [];
        gameData = [];
        for (y in 0...Levels.data.length) {
            var row = [];
            for (x in 0...Levels.data[y].length) {
                tileArray.push(Levels.data[y][x].item);

                var floorType = Wall;
                if (Levels.data[y][x].item == 6) {
                    floorType = Floor;
                }

                var item = { pos: { x: x, y: y }, floorType: floorType, player: null };

                if (x == playerPos.x && y == playerPos.y) {
                    item.player = player;
                }

                row.push(item);
            }

            gameData.push(row);
        }

        createTilemap(tileArray);

        add(player);
    }

    override public function update(elapsed:Float) {
        updateGameData();

        super.update(elapsed);
    }

    // LATER: around turning around in a square?
    function updateGameData () {
        var item:Null<LevelItem> = null;

        // TODO: buffer/recentcy system
        if (!player.moving) {
            if (FlxG.keys.pressed.LEFT) {
                item = getItem(player.pos.x - 1, player.pos.y);
            }

            if (FlxG.keys.pressed.RIGHT) {
                item = getItem(player.pos.x + 1, player.pos.y);
            }

            if (FlxG.keys.pressed.UP) {
                item = getItem(player.pos.x, player.pos.y - 1);
            }

            if (FlxG.keys.pressed.DOWN) {
                item = getItem(player.pos.x, player.pos.y + 1);
            }
        }

        // if player can move AND has pressed a direction
        if (item != null) {

            if (item.floorType == Floor) {
                player.move(item.pos);
                trace('can move!');
            } else {
                trace('can\'t move!');
            }
        }


    }

    function movePlayer () {
        // tween to new position
        // on complete, set to moving! false
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
