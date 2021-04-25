package objects;

import flixel.FlxSprite;

enum LightSize {
    Circle;
    Small;
    Large;
}

class Light extends FlxSprite {
    var size:LightSize;
    public function new (x:Float, y:Float, size:LightSize) {
        super(x, y);

        this.size = size;

        loadGraphic(AssetPaths.lights__png, true, 48, 48);

        animation.add('none', [0], 1);
        animation.add('circle', [1], 1);
        animation.add('circle-large', [2], 1);
        animation.add('small-ignite', [3, 4, 5], 12, false);
        animation.add('small-lit', [6, 7, 8], 12);
        animation.add('small-extiguish', [5, 4, 3], 12, false);
        animation.add('large-ignite', [9, 10, 11], 12, false);
        animation.add('large-lit', [12, 13, 14], 12);
        animation.add('large-extiguish', [11, 10, 9], 12, false);
        animation.finishCallback = animOnComplete;

        if (size == Circle) {
            animation.play('circle');
        } else {
            animation.play('none');
        }
    }

    function animOnComplete (animName:String) {
        if (animName == 'small-ignite') {
            animation.play('small-lit');
        }

        if (animName == 'large-ignite') {
            animation.play('large-lit');
        }

        if (animName == 'small-extinguish' || animName == 'large-extinguish') {
            animation.play('none');
        }
    }

    public function ignite () {
        // play sound
        if (size == Small) {
            animation.play('small-ignite');
        } else {
            animation.play('large-ignite');
        }
    }

    public function extinguish () {
        // play sound
        if (size == Small) {
            animation.play('small-extinguish');
        } else {
            animation.play('large-extinguish');
        }
    }
}