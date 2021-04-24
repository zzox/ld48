import PlayState;
import flixel.math.FlxPoint;

enum Dir {
    Left;
    Right;
    Up;
    Down;
}

class Utils {
    public static inline function translatePos (pos:ItemPos) {
        return new FlxPoint(pos.x * 16, pos.y * 16);
    }
}
