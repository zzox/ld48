package actors;

import Utils;
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
    var displayOffset:FlxPoint;
    var scene:PlayState;
    public var isFacing:Dir;
    public var moveTween:Null<FlxTween>;
    public var dead:Bool;

    public function new (x:Float, y:Float, name:String, pos:ItemPos, speed:Int, scene:PlayState, displayOffset:FlxPoint) {
        super(x + displayOffset.x, y + displayOffset.y);
        this.displayOffset = displayOffset;

        this.name = name;
        this.pos = pos;
        this.speed = speed;
        this.scene = scene;

        moving = false;
        dead = false;

        moveTween = null;
    }

    public function move (newPos:ItemPos) {
        if (dead) return;
        var worldPos:FlxPoint = Utils.translatePos(newPos);

        moving = true;

        moveTween = FlxTween.tween(
            this,
            { x: worldPos.x + displayOffset.x, y: worldPos.y + displayOffset.y },
            FPS / speed,
            { onComplete: (_:FlxTween) -> {
                this.moving = false;
            }}
        );

        pos = newPos;
    }
}
