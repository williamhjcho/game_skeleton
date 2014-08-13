/**
 * Created by William on 7/21/2014.
 */
package view {
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utils.graph.AStar;
import utils.graph.IGraph;

import utils.commands.clamp;

import utilsDisplay.base.BaseSprite;

public class TileBoard extends BaseSprite implements IGraph {

    private var tWidth:Number, tHeight:Number;
    private var mWidth:uint, mHeight:uint;
    private var board:Vector.<Tile>;
    private var tStart:Tile, tEnd:Tile;

    private var aStar:AStar;

    public function TileBoard(width:uint, height:uint, tileWidth:Number, tileHeight:Number) {
        super();
        aStar = new AStar(this);
        mWidth = width;
        mHeight = height;
        tWidth = tileWidth;
        tHeight = tileHeight;
        board = new Vector.<Tile>();
        for (var j:int = 0; j < height; j++) {
            for (var i:int = 0; i < width; i++) {
                var t:Tile = new Tile(tileWidth, tileHeight);
                addChildTo(t, i * (tileWidth), j * (tileHeight));
                board.push(t);
            }
        }
        tStart = new Tile(tileWidth, tileHeight); addChildTo(tStart, 0, 0); tStart.asStart();
        tEnd = new Tile(tileWidth, tileHeight); addChildTo(tEnd, (width-1) * tileWidth, (height-1) * tileHeight); tEnd.asEnd();

        render(-1, false, false, false, false);
        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        this.addEventListener(MouseEvent.MOUSE_UP, onUpBoard);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        for each (var tile:Tile in board) {
            tile.addEventListener(MouseEvent.MOUSE_DOWN, onDownBoard);
        }

        tStart.addEventListener(MouseEvent.MOUSE_DOWN, onDownPoint);
        tEnd.addEventListener(MouseEvent.MOUSE_DOWN, onDownPoint);
    }

    //==================================
    //  Public
    //==================================
    public function find(x0:uint, y0:uint, x1:uint, y1:uint):void {
        tStart.x = x0 * tWidth;
        tStart.y = y0 * tHeight;
        tEnd.x = x1 * tWidth;
        tEnd.y = y1 * tHeight;
        aStar.find(x0 + y0 * mWidth, x1 + y1 * mWidth);
        clearTileColors();
        render(-1, true, true, true, true, true);
        currentHistory = 0;
    }

    private var currentHistory:int = 0;
    public function next():void {
        var history:Vector.<Object> = aStar.history;
        if(currentHistory < history.length) {
            var h:Object = history[currentHistory++];
            trace("============");
            trace("current  : " + h.current  );
            trace("frontier : " + h.frontier );
            trace("neighbors: " + h.neighbors);
            trace("cost     : " + h.cost     );
            render(h.current, true, true, true, true, true);
        }
    }


    //==================================
    //  Private
    //==================================
    private function clearTileColors():void {
        for each (var tile:Tile in board) {
            tile.asIs();
        }
    }

    private function render(current:int, showNeighbors:Boolean = false, showPath:Boolean = false, showCost:Boolean = false, showPriority:Boolean = false, showDistance:Boolean = false):void {
        var neighbors:Vector.<int> = getNeighbors(current);

        var startIdx:int = tStart.px + tStart.py * mWidth,
                endIdx:int = tEnd.px + tEnd.py * mWidth;
        for (var i:int = 0; i < board.length; i++) {
            board[i].asIs();
            board[i].priority = (showPriority)? aStar.priorities[i] || "" : "";
            board[i].cost = (showCost)? aStar.cost_so_far[i] || "" : "";
            board[i].distance = (showDistance)? aStar.distances[i] || "" : "";

            if(i == startIdx) {
                tStart.priority = board[i].priority;
                tStart.cost = board[i].cost;
                tStart.distance = board[i].distance;
            }
            if(i == endIdx) {
                tEnd.priority = board[i].priority;
                tEnd.cost = board[i].cost;
                tEnd.distance = board[i].distance;
            }

            if(i == current) {
                board[i].asFocus();
            } else {
                if(showNeighbors && neighbors.indexOf(i) != -1) {
                    board[i].asNeighbor();
                }
                if(showPath && aStar.path.indexOf(i) != -1) {
                    board[i].asPath();
                }
            }
        }
    }

    private function calculateFromTiles():void {
        trace("(" +tStart.px + "," + tStart.py + ") -> (" + tEnd.px + "," + tEnd.py + ")");
        find(tStart.px, tStart.py, tEnd.px, tEnd.py);
    }

    //==================================
    //  Interface
    //==================================
    public function getNeighbors(tile:int):Vector.<int> {
        var wLower:Boolean = tile % mWidth > 0,
                wUpper:Boolean = tile % mWidth < mWidth - 1,
                hLower:Boolean = int(tile / mWidth) > 0,
                hUpper:Boolean = int(tile / mWidth) < mHeight - 1;
        var neighbors:Vector.<int> = new Vector.<int>();
        if(wUpper && board[tile + 1      ].walkable) neighbors.push(tile + 1     );     //right
        if(hUpper && board[tile + mWidth ].walkable) neighbors.push(tile + mWidth );    //down
        if(wLower && board[tile - 1      ].walkable) neighbors.push(tile - 1     );     //left
        if(hLower && board[tile - mWidth ].walkable) neighbors.push(tile - mWidth );    //up
        return neighbors;
    }

    public function getCost(a:int, b:int):Number {
        return 1;
    }

    public function getDistance(a:int, b:int):Number {
        //heuristic
        var xa:int = a % mWidth, ya:int = a / mWidth;
        var xb:int = b % mWidth, yb:int = b / mWidth;

        var dx1:int = xb - xa, dy1:int = yb - ya;
        var dx2:int = tStart.px - tEnd.px, dy2:int = tStart.py - tEnd.py;

        var cross:Number = 0.001 * Math.abs(dx1 * dy2 + dx2 * dy1);
        //this constant is for tie breakers, if > 1 it will prefer for nodes closer to the end
        //var p:Number = (1 + 1.0 / 1000);
        return (Math.abs(xa - xb) + Math.abs(ya - yb)) + cross;
    }


    //==================================
    //  Event
    //==================================
    private var direction:Boolean;

    private function onDownBoard(e:MouseEvent):void {
        var t:Tile = e.currentTarget as Tile;

        direction = !t.walkable;
        t.walkable = direction;

        for each (var tile:Tile in board) {
            tile.addEventListener(MouseEvent.MOUSE_OVER, onOverBoard);
        }
    }

    private function onUpBoard(e:MouseEvent):void {
        for each (var tile:Tile in board) {
            tile.removeEventListener(MouseEvent.MOUSE_OVER, onOverBoard);
        }
    }

    private function onOverBoard(e:MouseEvent):void {
        var t:Tile = e.currentTarget as Tile;
        if(t.walkable != direction) {
            t.walkable = direction;
        }
    }

    private function onDownPoint(e:MouseEvent):void {
        var t:Tile = e.currentTarget as Tile;
        t.startDrag(false, new Rectangle(0,0,(mWidth - 1) * tWidth, (mHeight - 1) * tHeight));
        t.addEventListener(MouseEvent.MOUSE_UP, onUpPoint);
    }

    private function onUpPoint(e:MouseEvent):void {
        var t:Tile = e.currentTarget as Tile;
        t.stopDrag();
        //snap to position
        var i:int = t.px, j:int = t.py;
        if((t.x % tWidth) > tWidth / 2) {
            i = clamp(i + 1, 0, mWidth - 1);
        }
        if((t.y % tHeight) > tHeight / 2) {
            j = clamp(j + 1, 0, mHeight - 1);
        }
        t.x = i * tWidth;
        t.y = j * tHeight;
        t.removeEventListener(MouseEvent.MOUSE_UP, onUpPoint);

        calculateFromTiles();
    }

    private function onKeyUp(e:KeyboardEvent):void {
        switch(e.keyCode) {
            case 39: {
                next();
                break;
            }
            case 37: {
                break;
            }
        }
    }
}
}
