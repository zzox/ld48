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
        rocks: [
            { x: 13, y: 1 }
        ],
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
        path: AssetPaths.floor_1__tmx,
        sound: 5,
        start: { x: 1, y: 1 },
        exit: null,
        gremlins: [],
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
    }, ];
}