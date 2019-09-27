public class BPM
{
    static dur bar, halfBar, quarterBar, eighthBar, sixteenthBar, thirtiethBar; 

    function void setBPM(float bpm) {
        60.0 / bpm => float spb;
        spb :: second => quarterBar;
        quarterBar * 2 => halfBar;
        halfBar * 2 => bar;
        quarterBar * .5 => eighthBar;
        eighthBar * .5 => sixteenthBar;
        sixteenthBar * .5 => thirtiethBar;
    }
}