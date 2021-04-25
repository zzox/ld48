package objects;

import flixel.tweens.FlxTween;
import objects.DItem.DItem;
import flixel.math.FlxPoint;
import PlayState;
import Utils;

enum ItemType {
    Torch;
    Rock;
}

class Item extends DItem {
    static inline final FPS = 60;
    static inline final THROW_SPEED = 600;
    public var type:ItemType;
    public var pos:ItemPos;
    public var moving:Bool;
    public var thrown:Null<Dir>;
    public var canLight:Bool;
    public var lit:Bool;
    public var held:Bool;
    var name:String;

    public var light:Light;

    public function new (x:Float, y:Float, type:ItemType, pos:ItemPos) {
        var startingPos:FlxPoint = Utils.translatePos(pos);

        super(startingPos.x, startingPos.y);
        loadGraphic(AssetPaths.items__png, true, 16, 16);

        if (type == Torch) {
            light = new Light(x - 16, y - 16, Large);
            name = 'torch';
            canLight = true;
        } else if (type == Rock) {
            name = 'rock';
            canLight = false;
        }

        this.pos = pos;
        this.type = type;

        thrown = null;
        held = false;
        lit = false;
        moving = false;

        animation.add('torch', [0], 1);
        animation.add('torch-held', [0], 1); // temp?
        animation.add('torch-lit', [2, 3, 4], 6);
        animation.add('torch-held-lit', [2, 3, 4], 6); // temp?
        animation.add('torch-thrown', [8, 9, 10, 11], 15);
        animation.add('torch-thrown-lit', [12, 13, 14, 15], 15);
        animation.add('rock', [16], 1);
        animation.add('rock-held', [16], 1); // temp?
        animation.add('rock-thrown', [16, 18, 19, 20], 15);
    }

    override public function update (elapsed:Float) {
        var anim = name;
        if (held) {
            anim += '-held';
            depth = 5;
        } else if (thrown != null) {
            anim += '-thrown';
            depth = 5;
        } else {
            depth = 1;
        }

        if (lit) {
            anim += '-lit';
        }

        animation.play(anim);

        if (light != null) {
            light.x = x - 16;
            light.y = y - 16;
        }

        super.update(elapsed);
    }

    public function throwMe (newPos:ItemPos, dir:Dir) {
        var worldPos:FlxPoint = Utils.translatePos(newPos);
        var speedCoefDist = dir == Left || dir == Right ? Math.abs(worldPos.x - x) : Math.abs(worldPos.y - y);
        var tweenTime = (FPS / THROW_SPEED) * (speedCoefDist == 0 ? 0.00000001 : speedCoefDist / 16);

        this.moving = true;
        thrown = dir;
        held = false;

        FlxTween.tween(
            this,
            {x: worldPos.x, y: worldPos.y },
            tweenTime,
            { onComplete: (_:FlxTween) -> { this.moving = false; } }
        );

        pos = newPos;
    }

    public function ignite () {
        lit = true;
        light.ignite();
    }

    public function extinguish () {
        lit = false;
        light.extinguish();
    }
}
