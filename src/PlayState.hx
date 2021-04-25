package;

import Utils;
import actors.Gremlin;
import actors.Player;
import data.Game;
import data.Levels;
import display.Lighting;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import objects.DItem;
import objects.Item;
import objects.Light;
import objects.TorchSet;

typedef LevelItem = {
    var start:Bool;
    var exit:Bool;
    var pos:ItemPos;
    var floorType:FloorType;
    var player:Null<Player>;
    var gremlin:Null<Gremlin>;
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
    var gremlins:Array<Gremlin>;

    public var lighting:Lighting;
    var blackCover:FlxSprite;

    public var levelOver:Bool;

    var cantSound:FlxSound; //
    var extinguishSound:FlxSound; //
    var igniteSound:FlxSound; //
    var pickupSound:FlxSound; //
    // var stepsSound:FlxSound; // sucks
    var downStepsSound:FlxSound; //
    var donShriekSound:FlxSound; //
    var gremlinShriekSound:FlxSound; //

    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;

        // TEMP: get from game singleton later
        var level = Game.inst.level;
        var levelData = Levels.data[level];
        // TODO: hold a torch if level 0

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
                    start: false,
                    exit: false,
                    pos: thisPos,
                    floorType: floorType,
                    player: null,
                    gremlin: null,
                    item: null,
                    thrownItem: null,
                    torchSet: null
                };

                row.push(item);
            }

            gameData.push(row);
        }

        var exitItem = getItem(levelData.exit.x, levelData.exit.y);
        exitItem.exit = true;
        var exitPos = Utils.translatePos(levelData.exit);
        add(new FlxSprite(exitPos.x, exitPos.y, AssetPaths.stair__png));

        player = new Player(0, 0, levelData.start, this);

        var startItem = getItem(levelData.start.x, levelData.start.y);
        startItem.start = true;
        startItem.player = player;

        displayGroup = new FlxTypedGroup<DItem>();
        displayGroup.add(player);

        for (rockItem in levelData.rocks) {
            var rock = new Item(0, 0, Rock, rockItem);

            var rockFloorItem = getItem(rockItem.x, rockItem.y);
            items.push(rock);
            rockFloorItem.item = rock;
            displayGroup.add(rock);
        }

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
            var torchSetPos:FlxPoint = Utils.translatePos(torchSetItem);
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

        gremlins = [];
        for (gremlinItem in levelData.gremlins) {
            var gremlinPos:FlxPoint = Utils.translatePos(gremlinItem.pos);
            var gremlin = new Gremlin(
                gremlinPos.x,
                gremlinPos.y,
                gremlinItem.pos,
                gremlinItem.type,
                this
            );

            var gremlinFloorItem = getItem(gremlinItem.pos.x, gremlinItem.pos.y);
            gremlinFloorItem.gremlin = gremlin;

            displayGroup.add(gremlin);
            gremlins.push(gremlin);
        }

        add(displayGroup);

        var alphaCoef = (level / 4 * 0.4) + 0.6;

        lighting = new Lighting();
        lighting.alpha = /*level == 0 ? 1 : */alphaCoef > 1 ? 1 : alphaCoef;
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

        for (gremlin in gremlins) {
            add(gremlin.eyes);
            lighting.add(gremlin.light);
        }
        // add logo if first level

        blackCover = new FlxSprite(0, 0);
        blackCover.makeGraphic(1, 1, 0xff000000);
        blackCover.setPosition(player.x + (player.width / 2), player.y + (player.height / 2));
        blackCover.setGraphicSize(FlxG.width * 2, FlxG.height * 2);
        FlxTween.tween(
            blackCover,
            { "scale.x": 0.001, "scale.y": 0.001 },
            0.5,
            { onComplete: (_:FlxTween) -> { blackCover.visible = false; }
        });
        add(blackCover);

        levelOver = false;

        cantSound = FlxG.sound.load(AssetPaths.cant__wav, 1);
        extinguishSound = FlxG.sound.load(AssetPaths.extinguish__wav, 1);
        igniteSound = FlxG.sound.load(AssetPaths.ignite__wav, 1);
        pickupSound = FlxG.sound.load(AssetPaths.pick_up__wav, 1);
        downStepsSound = FlxG.sound.load(AssetPaths.down_steps__wav, 1);
        donShriekSound = FlxG.sound.load(AssetPaths.don_shriek__wav, 1);
        gremlinShriekSound = FlxG.sound.load(AssetPaths.gremlin_shriek__wav, 1);

		if (FlxG.sound.defaultMusicGroup.sounds.length == 0) {
			FlxG.sound.play(AssetPaths.grem_theme_1__wav, 0, true, FlxG.sound.defaultMusicGroup, false);
			FlxG.sound.play(AssetPaths.grem_theme_2__wav, 0, true, FlxG.sound.defaultMusicGroup, false);
			FlxG.sound.play(AssetPaths.grem_theme_3__wav, 0, true, FlxG.sound.defaultMusicGroup, false);
			FlxG.sound.play(AssetPaths.grem_theme_4__wav, 0, true, FlxG.sound.defaultMusicGroup, false);
			FlxG.sound.play(AssetPaths.grem_theme_5__wav, 0, true, FlxG.sound.defaultMusicGroup, false);
			FlxG.sound.play(AssetPaths.grem_theme_6__wav, 0, true, FlxG.sound.defaultMusicGroup, false);
		}

		// need to use integers for now, since I don't know how to
		// properly name the sounds, I'm looking for a path variable or something
		for (i in 0...FlxG.sound.defaultMusicGroup.sounds.length) {
			var sound = FlxG.sound.defaultMusicGroup.sounds[i];
			sound.persist = true;

			var vol:Float = 0.0;
			if (levelData.sound == i) {
				vol = 1.0;
			}

			FlxTween.tween(sound, { volume: vol }, 1.5);
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
        // don't allow if level is over
        if (!player.moving && !levelOver) {
            if (FlxG.keys.pressed.LEFT) {
                var checked = checkItem({ x: player.pos.x - 1, y: player.pos.y });

                if (checked != null) {
                    toItem = checked;
                }

                player.isFacing = Left;
                player.flipX = false;
            }

            if (FlxG.keys.pressed.RIGHT) {
                var checked = checkItem({ x: player.pos.x + 1, y: player.pos.y });

                if (checked != null) {
                    toItem = checked;
                }

                player.isFacing = Right;
                player.flipX = true;
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
            if (toItem.exit) {
                winLevel();
            }

            if (toItem.floorType == Floor) {
                var currentPlayerItem = getItem(player.pos.x, player.pos.y);
                currentPlayerItem.player = null;
                player.move(toItem.pos);
                toItem.player = player;
            } else {
                if (!cantSound.playing) {
                    cantSound.play();
                }
            }
        }

        // throw/pick up logic
        if (FlxG.keys.anyJustPressed([SPACE, X])) {
            var didThrow:Bool = false;

            if (player.held != null) {
                var heldItem = player.held;
                heldItem.throwMe(player.pos, player.isFacing);
                var levelItem = getItem(player.pos.x, player.pos.y);
                levelItem.thrownItem = heldItem;

                player.held = null;

                igniteSound.play();

                didThrow = true;
            }

            // if we didn't throw something, we can try picking up something
            if (!didThrow) {
                var atItem = getItem(player.pos.x, player.pos.y);
                // switch the items out, temporarily held by nothing
                if (atItem.item != null) {
                    var tempItem = atItem.item;
                    atItem.item = null;

                    player.pickUp(tempItem);
                    pickupSound.play();
                } else {
                    if (!cantSound.playing) {
                        cantSound.play();
                    }
                }
            }
        }

        for (gremlin in gremlins) {
            if (!gremlin.moving) {
                var toItem = checkItemForGremlin(getItemFromDir(gremlin.pos, gremlin.dir));

                // if we can't move, we turn and try again next frame
                if (toItem != null) {
                    var currentGremlinItem = getItem(gremlin.pos.x, gremlin.pos.y);
                    currentGremlinItem.gremlin = null;
                    gremlin.move(toItem.pos);
                    toItem.gremlin = gremlin;

                    if (gremlin.dir == Right) {
                        gremlin.flipX = true;
                        gremlin.eyes.flipX = true;
                    }

                    if (gremlin.dir == Left) {
                        gremlin.flipX = false;
                        gremlin.eyes.flipX = false;
                    }
                } else {
                    gremlin.dir = gremlin.clockwise
                        ? Utils.clockwiseMap[gremlin.dir]
                        : Utils.counterClockwiseMap[gremlin.dir];
                }
            }

            if (!levelOver) {
                FlxG.overlap(gremlin, player, loseLevel);
            }
        }

        // check thrown, etc.
        for (item in items) {
            if (!item.moving && item.thrown != null) {
                var toItem = getItemFromDir(item.pos, item.thrown);

                if (toItem.gremlin != null) {
                    toItem.gremlin.killMe();
                    gremlinShriekSound.play();
                    toItem.gremlin = null;
                    drop(item, item.pos);
                    if (item.type == Torch) {
                        item.breakMe();
                    }

                    return;
                }

                if (item.type == Torch && toItem.torchSet != null) {
                    lightIfPossible(item, toItem.torchSet);
                }

                if (item.type == Rock) {
                    if (toItem.torchSet != null && toItem.torchSet.lit) {
                        toItem.torchSet.extinguish();
                        extinguishSound.play();
                    }

                    if (toItem.item != null && toItem.item.type == Torch && toItem.item.lit) {
                        toItem.item.extinguish();
                        extinguishSound.play();
                    }
                }

                if (toItem.floorType == Wall) {
                    drop(item, item.pos);
                    cantSound.play();
                } else {
                    item.throwMe(toItem.pos, item.thrown);
                }
            }
        }
    }

    function lightIfPossible (item:Item, torchSet:TorchSet) {
        if (item.lit && !torchSet.lit) {
            torchSet.light();
            igniteSound.play();
        }

        if (!item.lit && torchSet.lit) {
            item.ignite();
            igniteSound.play();
        }
    }

    public function drop (item:Item, pos:ItemPos) {
        item.held = false;
        item.thrown = null;

        var floorItem:LevelItem = getItem(pos.x, pos.y);
        if (floorItem.item != null) {
            if (floorItem.item.type == Rock) {
                item.breakMe();
            } else {
                floorItem.item.breakMe();
                floorItem.item = item;
            }
        } else {
            floorItem.item = item;
        }
    }

    function checkItem (pos:ItemPos):Null<LevelItem> {
        var item:LevelItem = getItem(pos.x, pos.y);
        if (item.floorType == Floor) {
            return item;
        }

        return null;
    }

    function checkItemForGremlin (levelItem:LevelItem):Null<LevelItem> {
        if (
            levelItem.floorType == Floor &&
            !levelItem.start &&
            !levelItem.exit &&
            !(levelItem.gremlin != null) &&
            !(levelItem.torchSet != null && levelItem.torchSet.lit) &&
            !(levelItem.item != null && levelItem.item.type == Torch && levelItem.item.lit)
        ) {
            return levelItem;
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

    function winLevel () {
        Game.inst.level++;
        levelOver = true;

        downStepsSound.play();

        // black graphic
        blackCover.visible = true;
        blackCover.setPosition(player.x + (player.width / 2), player.y + (player.height / 2));
        FlxTween.tween(blackCover, { "scale.x": FlxG.width * 2, "scale.y": FlxG.height * 2 }, 0.5);

        new FlxTimer().start(1, (_:FlxTimer) -> {
            FlxG.switchState(new PlayState());
        });
    }

    function loseLevel (gremlin:Gremlin, _:Player) {
        levelOver = true;
        player.die();
        gremlin.attack();

        donShriekSound.play();

        if (player.held != null) {
            drop(player.held, player.pos);
        }

        blackCover.visible = true;
        blackCover.setPosition(player.x + (player.width / 2), player.y + (player.height / 2));

        new FlxTimer().start(0.5, (_:FlxTimer) -> {
            FlxTween.tween(blackCover, { "scale.x": FlxG.width * 2, "scale.y": FlxG.height * 2 }, 0.5);
        });

        new FlxTimer().start(1, (_:FlxTimer) -> {
            FlxG.switchState(new PlayState());
        });
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
