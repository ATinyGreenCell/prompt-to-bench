// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, each hole placed by its bottom centre
// holes as rotated cylinders placed by their bottom centre
difference(){ translate([-65,-30,0]) cube([130,60,45]);
 for(i=[-2:2]) translate([i*24, -10 + 40*sin(30), 45 - 40*cos(30)]) rotate([30,0,0]) cylinder(d=17.5,h=60,$fn=64); }
