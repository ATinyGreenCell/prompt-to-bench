// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, as one extruded side profile with the holes cut after
// one 2-D side profile extruded, then holes
difference(){ translate([0,22,0]) rotate([90,0,0]) linear_extrude(44) union(){ translate([-56,0]) square([112,3]); translate([-56,22]) square([112,3]);
   translate([-56,0]) square([3,25]); translate([53,0]) square([3,25]); for(x=[-36:18:36]) translate([x-1.25,0]) square([2.5,25]); }
 for(x=[-45:18:45], y=[-9,9]) translate([x,y,23.5]) cube([13,13,5],center=true); }
