package actors;

import js.Browser;
import flixel.math.FlxPoint;
import objects.Item;
import PlayState;

class Player extends Actor {
    var scene:PlayState;
    var held:Null<Item>;

    public function new(x:Float, y:Float, pos:ItemPos, scene:PlayState) {
        var startingPos:FlxPoint = Utils.translatePos(pos);

        super(startingPos.x, startingPos.y, 'player', pos, 240);

        this.scene = scene;
        depth = 2;

        loadGraphic(AssetPaths.don__png, true, 24, 24);
        offset.set(9, 6);
        setSize(6, 12);

        animation.add('stand', [0]);
        animation.add('run', [0, 0, 1, 1, 1, 2, 2, 0, 0, 3, 3, 3, 4, 4], 24);

        animation.play('run');
    }

    override public function update (elapsed:Float) {
        // TODO: move to parent?
        if (moving) {
            animation.play('run');
        } else {
            animation.play('stand');
        }

        if (held != null) {
            held.x = x;
            held.y = y;
        }

        super.update(elapsed);
    }

    // if we are holding something, we drop it
    public function pickUp (item:Item) {
        if (held != null) {
            drop();
        }

        Browser.console.log('picked up', item);
        held = item;
        item.held = true;
        // play sound
    }

    // drop the item
    public function drop () {
        scene.drop(held, pos);
        Browser.console.log('dropped', held);

        // if the item held is being held its false,
        // then if we are holding something thats null lol
        held.held = false;
        held = null;
    }
}
