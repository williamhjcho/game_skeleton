/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 23/07/12
 * Time: 12:33
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.scroller {
public class ScrollParameters {

    //Expand/contract trackers, or keep them on fixed size
    public var relativeTrackH:Boolean = true;
    public var relativeTrackV:Boolean = true;
    public var relativeTrackerH:Boolean = true;
    public var relativeTrackerV:Boolean = true;
    public var relativeTrackers:Boolean = true;

    //Automatic position XY of tracks and trackers
    public var repositionV:Boolean = true;
    public var repositionH:Boolean = true;
    public var repositionAll:Boolean = true;

    //Distance container-trackers
    public var paddingH:Number = 5;
    public var paddingV:Number = 5;

    public var fade:Boolean = true;
    public var fadeTime:Number = 0.3;

    public var trackerMinWidth:Number = 20;   //minimum tracker size (if relativeTrackers = true)
    public var trackerMinHeight:Number = 20;

    public var wheelSpeed:Number = 15;


}
}
