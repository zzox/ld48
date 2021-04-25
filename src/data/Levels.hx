package data;

import actors.Gremlin;

class Levels {
    public static final data = [{
        path: AssetPaths.floor_1__tmx,
        sound: 0,
        start: { x: 1, y: 1 },
        exit: { x: 12, y: 8 },
        gremlins: [{
            pos: { x: 4, y: 4 }, type: Slow
        }, {
            pos: { x: 6, y: 1 }, type: Slow
        }, {
            pos: { x: 13, y: 1 }, type: Slow
        }, {
            pos: { x: 13, y: 6 }, type: Slow
        }],
        rocks: [
            { x: 13, y: 1 }
        ],
        torches: [
            { x: 1, y: 2 }
        ],
        torchSets: [
            { x: 1, y: 3 },
            { x: 1, y: 5 },
            { x: 1, y: 8 },
            { x: 13, y: 1 },
            { x: 13, y: 3 },
            { x: 13, y: 5 },
            { x: 13, y: 8 }
        ],
        litChance: 1,
        setLitChance: 0
    }, {
        path: AssetPaths.floor_1__tmx,
        sound: 1,
        start: { x: 12, y: 8 },
        exit: { x: 1, y: 1 },
        gremlins: [],
        rocks: [
            { x: 13, y: 1 }
        ],
        torches: [
            { x: 1, y: 2 }
        ],
        torchSets: [],
        litChance: 0.5,
        setLitChance: 0
    }, {
        path: AssetPaths.floor_1__tmx,
        sound: 2,
        start: { x: 12, y: 8 },
        exit: { x: 1, y: 1 },
        gremlins: [],
        rocks: [
            { x: 13, y: 1 }
        ],
        torches: [
            { x: 1, y: 2 }
        ],
        torchSets: [],
        litChance: 0.5,
        setLitChance: 0
    }];
}