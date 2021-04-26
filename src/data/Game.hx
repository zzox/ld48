package data;

import objects.Item;

class Game {
    public static final inst:Game = new Game();
    public var level:Int;

    private function new () {
        restart();
    }

    public function restart() {
        level = 0;
    }
}
