// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, stacked linear_extrude()s, the cone by scale
$fn=128;
difference(){ union(){ linear_extrude(4) circle(d=50); translate([0,0,4]) linear_extrude(10, scale=22/50) circle(d=50); translate([0,0,14]) linear_extrude(19) circle(d=22); }
 translate([0,0,6]) cylinder(d1=3,d2=11,h=17.01); translate([0,0,23]) cylinder(d=11,h=11);
 translate([0,-2,18]) cube([12,4,12]); }
