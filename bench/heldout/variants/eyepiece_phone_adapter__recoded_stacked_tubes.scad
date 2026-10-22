// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, the sleeve as two stacked tubes
$fn=96;
module tube(od,id,h) difference(){ cylinder(d=od,h=h); translate([0,0,-1]) cylinder(d=id,h=h+2); }
difference(){ union(){ difference(){ translate([-40,-30,0]) cube([80,60,3]); translate([-20,10,-1]) cylinder(d=12,h=5);} 
 translate([-20,10,3]) tube(36.6,22,8); translate([-20,10,11]) tube(36.6,30.6,20); }
 for(a=[0:120:240]) translate([-20,10,21]) rotate([0,0,a]) translate([14,0,0]) rotate([0,90,0]) cylinder(d=2.5,h=6,$fn=24); }
