package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.scaleModes.PixelPerfectScaleMode;

class PlayState extends FlxState {
    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
