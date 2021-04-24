package objects;

import flixel.FlxSprite;

/**
    Item with depth for displaylist sorting
**/
class DItem extends FlxSprite {
    public var depth:Int;
    public function new (x:Float, y:Float) {
        super(x, y);
        depth = 1;
    }
}
