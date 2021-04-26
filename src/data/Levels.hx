package data;

import actors.Gremlin;
import PlayState;

typedef LevelData = {
    var path:String;
    var sound:Int;
    var start:ItemPos;
    var exit:Null<ItemPos>;
    var gremlins:Array<Dynamic>; // BAD!
    var torches:Array<Dynamic>; // BAD!
    var rocks:Array<Dynamic>; // BAD!
    var torchSets:Array<Dynamic>; // BAD!
}

class Levels {
    public static final data:Array<LevelData> = [{
        path: AssetPaths.floor_1__tmx,
        sound: 0,
        start: { x: 1, y: 1 },
        exit: { x: 12, y: 8 },
        gremlins: [{
            pos: { x: 3, y: 3 }, type: Slow
        }, {
            pos: { x: 11, y: 3 }, type: Medium
        }, {
            pos: { x: 3, y: 6 }, type: Slow
        }, {
            pos: { x: 11, y: 6 }, type: Fast
        }],
        torches: [{
            pos: { x: 1, y: 2 }, lit: true
        }],
        rocks: [],
        torchSets: [{
            pos: { x: 1, y: 3 }, lit: false
        }, {
            pos: { x: 1, y: 5 }, lit: false
        }, {
            pos: { x: 1, y: 8 }, lit: false
        }, {
            pos: { x: 13, y: 1 }, lit: false
        }, {
            pos: { x: 13, y: 3 }, lit: false
        }, {
            pos: { x: 13, y: 5 }, lit: false
        }, {
            pos: { x: 13, y: 8 }, lit: false
        }]
    }, {
        path: AssetPaths.floor_2__tmx,
        sound: 1,
        start: { x: 12, y: 8 },
        exit: { x: 4, y: 3 },
        gremlins: [],
        torches: [{
            pos: { x: 13, y: 5 }, lit: true
        }],
        rocks: [
            { x: 13, y: 1 }
        ],
        torchSets: [{
            pos: { x: 3, y: 7 }, lit: false
        }, {
            pos: { x: 7, y: 7 }, lit: false
        }, {
            pos: { x: 11, y: 7 }, lit: false
        }, {
            pos: { x: 13, y: 1 }, lit: true
        }, {
            pos: { x: 1, y: 1 }, lit: true
        }]
    }, {
        path: AssetPaths.floor_3__tmx,
        sound: 2,
        start: { x: 4, y: 3 },
        exit: { x: 1, y: 1 },
        gremlins: [{
            pos: { x: 12, y: 8 }, type: Slow
        }],
        rocks: [
            { x: 13, y: 1 }
        ],
        torches: [{
            pos: { x: 1, y: 8 }, lit: true
        }],
        torchSets: [{
            pos: { x: 3, y: 7 }, lit: false
        }, {
            pos: { x: 7, y: 7 }, lit: false
        }, {
            pos: { x: 11, y: 7 }, lit: false
        }]
    }, {
        path: AssetPaths.floor_4__tmx,
        sound: 3,
        start: { x: 1, y: 1 },
        exit: { x: 8, y: 4 },
        gremlins: [{
            pos: { x: 8, y: 6 }, type: Medium
        }, {
            pos: { x: 13, y: 1 }, type: Slow
        }],
        rocks: [
            { x: 3, y: 1 }
        ],
        torches: [{
            pos: { x: 1, y: 1 }, lit: false
        }],
        torchSets: [{
            pos: { x: 3, y: 1 }, lit: true
        }, {
            pos: { x: 10, y: 1 }, lit: true
        }, {
            pos: { x: 11, y: 7 }, lit: true
        }]
    }, {
        path: AssetPaths.floor_5__tmx,
        sound: 4,
        start: { x: 8, y: 4 },
        exit: { x: 7, y: 8 },
        gremlins: [{
            pos: { x: 12, y: 8 }, type: Slow
        }, {
            pos: { x: 6, y: 1 }, type: Medium
        }, {
            pos: { x: 1, y: 8 }, type: Fast
        }],
        rocks: [
            { x: 1, y: 1 },
            { x: 13, y: 1 }
        ],
        torches: [{
            pos: { x: 8, y: 4 }, lit: false
        }],
        torchSets: [{
            pos: { x: 1, y: 1 }, lit: true
        }, {
            pos: { x: 13, y: 1 }, lit: true
        }, {
            pos: { x: 6, y: 3 }, lit: false
        }, {
            pos: { x: 6, y: 3 }, lit: false
        }, {
            pos: { x: 2, y: 6 }, lit: false
        }, {
            pos: { x: 12, y: 6 }, lit: false
        }]
    }, {
        path: AssetPaths.floor_1__tmx,
        sound: 5,
        start: { x: 7, y: 8 },
        exit: null,
        gremlins: [],
        torches: [{
            pos: { x: 8, y: 1 }, lit: true
        }, {
            pos: { x: 7, y: 8 }, lit: false
        }],
        rocks: [],
        torchSets: [{
            pos: { x: 1, y: 1 }, lit: false
        }, {
            pos: { x: 1, y: 3 }, lit: false
        }, {
            pos: { x: 1, y: 5 }, lit: false
        }, {
            pos: { x: 1, y: 8 }, lit: false
        }, {
            pos: { x: 13, y: 1 }, lit: false
        }, {
            pos: { x: 13, y: 3 }, lit: false
        }, {
            pos: { x: 13, y: 5 }, lit: false
        }, {
            pos: { x: 13, y: 8 }, lit: false
        }]
    }, ];
}