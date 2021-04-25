package data;

import objects.Item;

class Game {
    public static final inst:Game = new Game();

    public var heldItem:Null<Item>;
    public var level:Int;

    private function new () {
        restart();
    }

    public function restart() {
        heldItem = null;
        level = 0;
    }
}
