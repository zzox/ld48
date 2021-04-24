package actors;

import flixel.math.FlxPoint;
import PlayState;

class Player extends Actor {
    var scene:PlayState;

    public function new(x:Float, y:Float, pos:ItemPos, scene:PlayState) {
        var startingPos:FlxPoint = Utils.translatePos(pos);

        super(startingPos.x, startingPos.y, 'player', pos, 240);

        this.scene = scene;

        loadGraphic(AssetPaths.don__png, true, 24, 24);
        offset.set(9, 6);
        setSize(6, 12);

        animation.add('stand', [0]);
        animation.add('run', [0, 0, 1, 1, 1, 2, 2, 0, 0, 3, 3, 3, 4, 4], 24);

        animation.play('run');
    }

    override public function update (elapsed:Float) {
        // TODO: move to parent?
        if (moving) {
            animation.play('run');
        } else {
            animation.play('stand');
        }

        super.update(elapsed);
    }
}
