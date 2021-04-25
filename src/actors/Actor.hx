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

    public function new (x:Float, y:Float, name:String, pos:ItemPos, speed:Int, scene:PlayState, displayOffset:FlxPoint) {
        super(x + displayOffset.x, y + displayOffset.y);
        this.displayOffset = displayOffset;

        this.name = name;
        this.pos = pos;
        this.speed = speed;
        this.scene = scene;

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

    override function update (elapsed:Float) {
        if (!scene.levelOver || name == 'player') {
            super.update(elapsed);
        }
    }
}
