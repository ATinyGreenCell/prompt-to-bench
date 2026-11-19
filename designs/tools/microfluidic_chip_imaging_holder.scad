// Microfluidic chip imaging holder — parametric lab-printable variant
// Category: tools; holds a flat microfluidic chip and exposes an unobstructed optical window
// Print flat, without supports; check actual chip fit before handling biological material
// SPDX-License-Identifier: CERN-OHL-P-2.0
/* [Dimensions (mm)] */
base_x=100;  // [80:1:120]
base_y=70;   // [60:1:100]
base_h=6;    // [4:0.5:12]
window_x=60; // [40:1:70]
window_y=30; // [20:1:40]
hole_d=5;    // [3:0.5:7]
mount_pitch_x=80;
mount_pitch_y=50;
rail_len=64;
rail_width=3;
rail_height=4;
rail_y=20.5;
/* [Hidden] */
marker_len=7;
marker_width=7;
marker_height=2;
marker_x=39;
eps=0.05;
$fn=72;
assert(base_x > window_x + 12, "base too narrow for window and rails");
assert(base_y > window_y + 12, "base too shallow for window and rails");
assert(mount_pitch_x/2 + hole_d/2 < base_x/2-0.8, "mounting hole hits outer edge");
assert(mount_pitch_y/2 + hole_d/2 < base_y/2-0.8, "mounting hole hits outer edge");
assert(rail_y-rail_width/2 > window_y/2+0.5, "rail would obstruct imaging window");
assert(rail_y+rail_width/2 < base_y/2-0.8, "rail would extend outside base");
assert(marker_x+marker_len/2 < base_x/2-0.8, "marker would protrude from base");
assert(rail_len < base_x-1.6, "rail would protrude beyond base ends");
union(){
 difference(){
  translate([-base_x/2,-base_y/2,0]) cube([base_x,base_y,base_h]);
  translate([-window_x/2,-window_y/2,-eps]) cube([window_x,window_y,base_h+2*eps]);
  for(x=[-mount_pitch_x/2,mount_pitch_x/2]) for(y=[-mount_pitch_y/2,mount_pitch_y/2])
   translate([x,y,-eps]) cylinder(d=hole_d,h=base_h+2*eps);
 }
 for(y=[-rail_y,rail_y])
  translate([-rail_len/2,y-rail_width/2,base_h-eps]) cube([rail_len,rail_width,rail_height+eps]);
 translate([marker_x-marker_len/2,-marker_width/2,base_h-eps]) cube([marker_len,marker_width,marker_height+eps]);
}
