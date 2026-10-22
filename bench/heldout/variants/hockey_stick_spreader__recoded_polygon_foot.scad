// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, the foot as a polygon from its corners
$fn=64; u=[cos(120),sin(120)]; n=[cos(30),sin(30)]*2.5;
difference(){ union(){ translate([0,-3,0]) cube([150,6,4]); linear_extrude(2.5) polygon([n, 40*u+n, 40*u-n, -n]); cylinder(d=6,h=4); }
 translate([143,0,-1]) cylinder(d=4,h=6); }
