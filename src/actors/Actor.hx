package actors;

import PlayState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import objects.DItem;

class Actor extends DItem {
    static inline final FPS = 60;
    var name:String;
    public var pos:ItemPos;
    public var moving:Bool;
    var speed:Int;
    var displayOffset:FlxPoint = new FlxPoint();

    public function new (x:Float, y:Float, name:String, pos:ItemPos, speed:Int, ?displayOffset:FlxPoint) {
        if (displayOffset != null) {
            this.displayOffset = displayOffset;
        }

        super(x + displayOffset.x, y + displayOffset.y);
        this.name = name;
        this.pos = pos;
        this.speed = speed;

        moving = false;
    }

    public function move (newPos:ItemPos) {
        var worldPos:FlxPoint = Utils.translatePos(newPos);

        moving = true;

        FlxTween.tween(
            this,
            { x: worldPos.x + displayOffset.x, y: worldPos.y + displayOffset.y },
            FPS / speed,
            { onComplete: (_:FlxTween) -> { this.moving = false; } }
        );

        pos = newPos;
    }
}
