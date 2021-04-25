package actors;

import flixel.math.FlxPoint;
import flixel.util.FlxPool;
import haxe.display.JsonModuleTypes.JsonEnumField;
import flixel.util.FlxTimer;
import PlayState;
import flixel.FlxSprite;
import objects.Light;

enum GremlinType {
    Slow;
    Medium;
    Fast;
}

typedef GremlinData = {
    var blinkTime:Float;
    var speed:Int;
    var color:Int;
}

class Gremlin extends Actor {
    public var eyes:FlxSprite;
    var light:Light;
    var clockWise:Bool;
    var dead:Bool;

    static final gremlinMap:Map<GremlinType, GremlinData> = [
        Slow => {
            blinkTime: 2.5,
            speed: 120,
            color: 0xffffe737
        },
        Medium => {
            blinkTime: 5,
            speed: 240,
            color: 0xffffe737
        },
        Fast => {
            blinkTime: 10,
            speed: 360,
            color: 0xffffe737
        }
    ];

    public function new (x:Float, y:Float, pos:ItemPos, type:GremlinType, scene:PlayState) {
        var gremData = Gremlin.gremlinMap[type];
        super(x, y, 'gremlin', pos, gremData.speed, scene, new FlxPoint());
        
        loadGraphic(AssetPaths.gremlin__png, true, 16, 16);
        animation.add('creep', [0], 1);
        animation.add('attack', [1, 2, 3, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1], 20, false);
        animation.finishCallback = (animName:String) -> {
            if (animName == 'attack') {
                if (dead) {
                    eyes.kill();
                    this.kill();
                }

                animation.play('creep');
            }
        }

        depth = 4;

        eyes = new Eyes(x, y, gremData.blinkTime, gremData.color);

        isFacing = Math.random() > 0.5 ? Left : Right;
        clockWise = Math.random() > 0.5;

        dead = false;
    }

    public function killMe () {
        dead = true;
        animation.play('attack');
        light.extinguish();
        hideEyes(true);
    }

    public function attack () {
        animation.play('attack');
        light.extinguish();
        hideEyes(false);
    }

    function hideEyes (die:Bool) {
        eyes.visible = false;
        new FlxTimer().start(1, (_:FlxTimer) -> {
            if (!die) {
                eyes.visible = true;
            }
        });
    }

    override public function update (elapsed:Float) {
        super.update(elapsed);

        eyes.setPosition(x, y);
    }
}

class Eyes extends FlxSprite {
    var blinkTime:Float;
    var time:Float;

    public function new (x:Float, y:Float, blinkTime:Float, color:Int) {
        super(x, y);

        this.blinkTime = blinkTime;
        this.color = color;

        loadGraphic(AssetPaths.gremlin_eyes__png, true, 16, 16);
        animation.add('closed', [0], 1);
        animation.add('blink', [1, 2, 2, 1], 10, false);
        animation.finishCallback = (animName:String) -> {
            if (animName == 'blink') {
                animation.play('closed');
            }
        }

        time = 1.0; // about how much it takes to get started
    }

    override public function update (elapsed:Float) {
        time -= elapsed;
        if (time <= 0) {
            animation.play('blink');
            time += blinkTime + Math.random() * blinkTime;
        }

        super.update(elapsed);
    }
}
