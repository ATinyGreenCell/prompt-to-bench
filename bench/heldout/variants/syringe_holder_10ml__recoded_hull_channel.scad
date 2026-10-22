// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, the barrel channel as a hull()
$fn=64;
difference(){ translate([-25,-15,0]) cube([50,30,40]);
 translate([0,0,-1]) hull(){ cylinder(r=8.25,h=42); translate([-8.25,-20,0]) cube([16.5,1,42]); }
 translate([-17,-20,30]) cube([34,31,2.6]);
 for(x=[-19,19]) translate([x,20,15]) rotate([90,0,0]) cylinder(d=4.5,h=40); }
