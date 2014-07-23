/**
 * Created by William on 7/23/2014.
 */
package graph {
public interface IGraph {
    function getNeighbors(tile:int):Vector.<int>;
    function getCost(a:int, b:int):Number;
    function getDistance(a:int, b:int):Number;

}
}
