package actors;

import PlayState;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Actor extends FlxSprite {
    static inline final FPS = 60;
    var name:String;
    public var pos:ItemPos;
    public var moving:Bool;
    var speed:Int;

    public function new (x:Float, y:Float, name:String, pos:ItemPos, speed:Int) {
        super(x, y);
        this.name = name;
        this.pos = pos;
        this.speed = speed;

        moving = false;
    }

    public function move (newPos:ItemPos) {
        var worldPos:FlxPoint = Utils.translatePos(newPos);

        moving = true;

        trace(FPS / speed);

        FlxTween.tween(
            this,
            { x: worldPos.x, y: worldPos.y },
            FPS / speed,
            { onComplete: (_:FlxTween) -> { this.moving = false; } }
        );

        pos = newPos;
    }
}
