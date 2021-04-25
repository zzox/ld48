import PlayState;
import flixel.math.FlxPoint;

enum Dir {
    Left;
    Right;
    Up;
    Down;
}

class Utils {
    public static final clockwiseMap:Map<Dir, Dir> = [
        Left => Up,
        Up => Right,
        Right => Down,
        Down => Left
    ];

    public static final counterClockwiseMap:Map<Dir, Dir> = [
        Left => Down,
        Down => Right,
        Right => Up,
        Up => Left
    ];

    public static inline function translatePos (pos:ItemPos) {
        return new FlxPoint(pos.x * 16, pos.y * 16);
    }
}
