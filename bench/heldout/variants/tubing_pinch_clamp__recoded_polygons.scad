// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, the jaws as polygons, the hinge as a cut ring
// polygons and a rotate_extrude-free hinge
linear_extrude(8) {
 polygon([[0,0],[50,0],[50,2.5],[56,2.5],[56,4],[0,4]]);
 translate([0,12]) square([60,4]);
 difference(){ translate([0,8]) circle(r=8,$fn=96); translate([0,8]) circle(r=7.2,$fn=96); translate([0,-1]) square([20,20]); }
 for(y=[4,12]) translate([27.5,y]) circle(r=1.5,$fn=32);
 translate([57,4.5]) square([3,7.6]); translate([54.5,4.5]) square([2.6,1]); }
