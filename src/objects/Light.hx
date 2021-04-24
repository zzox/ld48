package objects;

import flixel.FlxSprite;

class Light extends FlxSprite {
    public function new (x:Float, y:Float) {
        super(x, y);

        // needs a "none" animation
        // animation.onComplete = () ->

        // small and large?
    }

    function animOnComplete (animName:String) {
        if (animName == 'ignite') {
            animation.play('lit');
        }

        if (animName == 'extinguish') {
            animation.play('none');
        }
    }

    public function ignite () {
        // play sound
        // play light, which triggers
    }

    public function extinguish () {
        // play sound
        // play ignite in reerse, then play none
    }
}