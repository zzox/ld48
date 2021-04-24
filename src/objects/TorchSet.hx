package objects;

import js.Browser;
import PlayState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class TorchSet extends FlxGroup {
    var torches:Array<FlxSprite>;
    var lightItems:Array<Light>;
    public var pos:ItemPos;
    public var lit:Bool;
    var x:Float;
    var y:Float;

    public function new (x:Float, y:Float, pos:ItemPos, lit:Bool = false) {
        super();
        this.x = x;
        this.y = y;
        this.pos = pos;
        this.lit = lit;

        lightItems = [];
        torches = [];
    }

    public function addItems (left:Bool, right:Bool, up:Bool, down:Bool) {
        if (left) {
            torches.push(new FlxSprite(x - 3, y + 6));
        }
        
        if (right) {
            torches.push(new FlxSprite(x + 12, y + 6));
        }

        if (up) {
            torches.push(new FlxSprite(x + 5, y - 6));
        }

        if (down) {
            torches.push(new FlxSprite(x + 5, y + 13));
        }

        for (torch in torches) {
            torch.loadGraphic(AssetPaths.small_torch__png, true, 8, 8);
            torch.animation.add('out', [0], 1);
            torch.animation.add('lit', [1, 2, 3, 4], 10);

            add(torch);

            // add light!
        }

        lit ? light() : extinguish();
    }

    public function light () {
        for (torch in torches) {
            torch.animation.play('lit');
        }

        for (light in lightItems) {
            light.ignite();
        }

        lit = true;
    }

    public function extinguish () {
        for (torch in torches) {
            torch.animation.play('out');
        }

        for (light in lightItems) {
            light.extinguish();
        }

        lit = false;
    }

    override function update (elapsed:Float) {
        for (torch in torches) {
            torch.update(elapsed);
        }
    }
}
