import PlayState;
import flixel.math.FlxPoint;

class Utils {
    public static inline function translatePos (pos:ItemPos) {
        return new FlxPoint(pos.x * 16, pos.y * 16);
    }
}
