package;

import data.Levels;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;

typedef LevelItem = {
    var item:Int;
}

class PlayState extends FlxState {
    static inline final TILE_SIZE = 16;

    override public function create() {
        super.create();

        // camera.pixelPerfectRender = true;

        createTilemap(Levels.data);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }

    function createTilemap (data:Array<Array<LevelItem>>) {
        var tileArray = [];

        for (y in 0...data.length) {
            for (x in 0...data[y].length) {
                tileArray.push(data[y][x].item);
            }
        }

        var tileMap = new FlxTilemap();
        tileMap.loadMapFromArray(tileArray, 15, 10, AssetPaths.tiles__png, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 1, 1, 1);
        tileMap.useScaleHack = false;
        add(tileMap);
    }
}
