// Dimensions (mm) - measured with calipers
base_dia = 50;
base_h = 4;
cone_top_dia = 50;
cone_bot_dia = 22;
cone_h = 10; // z=4 to z=14
col_dia = 22;
col_h = 19; // z=14 to z=33
seat_dia = 11;
seat_h = 10; // z=33 down to z=23
tip_dia = 3;
tip_z = 6;
window_w = 4;
window_z1 = 18;
window_z2 = 30;

$fn = 64;

// Base disc
translate([0, 0, 0])
  cylinder(h = base_h, r = base_dia / 2, center = false);

// Cone from z=4 to z=14
translate([0, 0, base_h])
  cylinder(h = cone_h, r1 = cone_top_dia / 2, r2 = cone_bot_dia / 2, center = false);

// Column from z=14 to z=33
translate([0, 0, base_h + cone_h])
  cylinder(h = col_h, r = col_dia / 2, center = false);

// Tube seat (cylindrical part) from z=23 to z=33
translate([0, 0, tip_z + seat_h])
  cylinder(h = seat_h, r = seat_dia / 2, center = false);

// Tube seat (conical part) from z=6 to z=23
// This cone narrows from seat_dia at z=23 to tip_dia at z=6
cone_seat_h = 23 - tip_z;
translate([0, 0, tip_z])
  cylinder(h = cone_seat_h, r1 = tip_dia / 2, r2 = seat_dia / 2, center = false);

// Viewing window cutout on +X side
// The window is 4mm wide in Y, from z=18 to z=30
// It cuts through the column wall on the +X side
// Column radius is col_dia/2 = 11mm
// Window extends from the seat (r=5.5mm) to outside (r=11mm)
translate([col_dia / 2 - 0.5, 0, (window_z1 + window_z2) / 2])
  cube([col_dia / 2 + 1, window_w, window_z2 - window_z1 + 0.02], center = true);