package objects;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import PlayState;

enum ItemType {
    Torch;
    Rock;
}

class Item extends FlxSprite {
    var position:ItemPos;
    var thrown:Bool;
    var canLight:Bool;
    public var lit:Bool;
    public var held:Bool;
    var name:String;

    public function new (x:Float, y:Float, type:ItemType, pos:ItemPos) {
        var startingPos:FlxPoint = Utils.translatePos(pos);

        super(startingPos.x, startingPos.y);
        loadGraphic(AssetPaths.items__png, true, 16, 16);

        if (type == Torch) {
            // TODO: add Light here!
            name = 'torch';
            canLight = true;
        } else if (type == Rock) {
            name = 'rock';
            canLight = false;
        }

        thrown = false;
        held = false;
        lit = false;

        animation.add('torch', [0], 1, true);
        animation.add('torch-held', [0, 1], 1, true);
        animation.add('torch-lit', [2, 3, 4], 1, true);
        animation.add('torch-held-lit', [2, 3, 4, 5, 6, 7], 1, true);
        animation.add('torch-thrown', [8, 9, 10, 11], 10, true);
        animation.add('torch-thrown-lit', [12, 13, 14, 15], 10, true);
        animation.add('rock', [16], 1, true);
        animation.add('rock-held', [16, 17], 1, true);
        animation.add('rock-thrown', [16, 18, 19, 20], 10, true);
    }

    public function check () {
        // if thrown, and ! moving, we
            // check to see if we keep going or not.
            // if so, we check if we can light
            // if not, we put the item on the ground
    }

    override public function update (elapsed:Float) {
        var anim = name;
        if (held) {
            anim += '-held';
        } else if (thrown) {
            anim += '-thrown';
        }

        if (lit) {
            anim += 'lit';
        }

        animation.play(anim);

        // if there is a light, update its position

        super.update(elapsed);
    }
}
