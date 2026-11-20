// Microfluidic chip imaging holder — reference solution
// Category: tools; purpose: repeatable positioning during optical chip imaging
// Print on flat base with z=0 on bed; PLA/PETG, no supports; not certified for clinical or sterile use
// SPDX-License-Identifier: CERN-OHL-P-2.0
$fn=72;
eps=0.05;
base_x=100;
base_y=70;
base_h=6;
window_x=60;
window_y=30;
hole_d=5;
hole_pitch_x=80;
hole_pitch_y=50;
rail_len=64;
rail_width=3;
rail_h=4;
rail_center_y=20.5;
marker_x=7;
marker_y=7;
marker_h=2;
marker_center_x=39;
assert(base_x > window_x + 2*hole_d);
assert(base_y > window_y + 2*hole_d);
assert(hole_pitch_x/2+hole_d/2 < base_x/2);
assert(hole_pitch_y/2+hole_d/2 < base_y/2);
assert(rail_center_y - rail_width/2 > window_y/2);
module reference(){
 union(){
  difference(){
   translate([-base_x/2,-base_y/2,0]) cube([base_x,base_y,base_h]);
   translate([-window_x/2,-window_y/2,-eps]) cube([window_x,window_y,base_h+2*eps]);
   for(x=[-hole_pitch_x/2,hole_pitch_x/2])
    for(y=[-hole_pitch_y/2,hole_pitch_y/2])
     translate([x,y,0.9]) cylinder(d=hole_d,h=base_h+2*eps);
  }
  for(y=[-rail_center_y,rail_center_y])
   translate([-rail_len/2,y-rail_width/2,base_h-eps])
    cube([rail_len,rail_width,rail_h+eps]);
  translate([marker_center_x-marker_x/2,-marker_y/2,base_h-eps])
   cube([marker_x,marker_y,marker_h+eps]);
 }
}
reference();
