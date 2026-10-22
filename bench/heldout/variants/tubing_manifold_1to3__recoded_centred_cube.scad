// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, a centred cube with rotated cylinder cutters
$fn=32;
difference(){ cube([60,24,16],center=true);
 rotate([0,90,0]) translate([0,0,-31]) cylinder(d=4.2,h=9);
 rotate([0,90,0]) translate([0,0,-31]) cylinder(d=3,h=46);
 for(x=[-15,0,15]) translate([x,0,0]) rotate([-90,0,0]) { cylinder(d=3,h=13); translate([0,0,6]) cylinder(d=4.2,h=7); }
 for(x=[-25,25]) translate([x,-6,0]) cylinder(d=3.4,h=20,center=true); }
