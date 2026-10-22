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

// Cone
translate([0, 0, base_h])
  cylinder(h = cone_h, r1 = cone_top_dia / 2, r2 = cone_bot_dia / 2, center = false);

// Column
translate([0, 0, base_h + cone_h])
  cylinder(h = col_h, r = col_dia / 2, center = false);

// Tube seat (cylindrical part)
translate([0, 0, base_h + cone_h + col_h - seat_h])
  cylinder(h = seat_h, r = seat_dia / 2, center = false);

// Tube seat (conical tip part)
// From z=23 down to z=6, diameter goes from 11 to 3
cone_seat_h = 23 - tip_z; // 17 mm
translate([0, 0, tip_z])
  cylinder(h = cone_seat_h, r1 = tip_dia / 2, r2 = seat_dia / 2, center = false);

// Viewing window cut
// Cut through the column wall on +X side
// Window is 4 mm wide in Y, from z=18 to z=30
// It goes from the seat (inner radius) to the outside (outer radius)
// Inner radius = seat_dia/2 = 5.5 mm
// Outer radius = col_dia/2 = 11 mm
// So the cut extends from x = 5.5 to x = 11 (and beyond to ensure clean cut)
// Centered in Y at 0, width 4 mm means Y from -2 to +2

difference() {
  // The solid part is already built above, but we need to subtract the window
  // We'll rebuild the column and seat parts here for the difference operation
  // Actually, let's use a different approach: subtract the window from the entire assembly
  
  // Rebuild the entire solid for the difference operation
  union() {
    // Base disc
    translate([0, 0, 0])
      cylinder(h = base_h, r = base_dia / 2, center = false);
    
    // Cone
    translate([0, 0, base_h])
      cylinder(h = cone_h, r1 = cone_top_dia / 2, r2 = cone_bot_dia / 2, center = false);
    
    // Column
    translate([0, 0, base_h + cone_h])
      cylinder(h = col_h, r = col_dia / 2, center = false);
    
    // Tube seat (cylindrical part)
    translate([0, 0, base_h + cone_h + col_h - seat_h])
      cylinder(h = seat_h, r = seat_dia / 2, center = false);
    
    // Tube seat (conical tip part)
    translate([0, 0, tip_z])
      cylinder(h = cone_seat_h, r1 = tip_dia / 2, r2 = seat_dia / 2, center = false);
  }
  
  // Subtract the viewing window
  // The window is on the +X side, so we place the cut box at positive X
  // It goes from the inner surface (seat_dia/2) to beyond the outer surface (col_dia/2 + 1mm)
  // Y is centered at 0, width 4 mm
  // Z from window_z1 to window_z2
  
  translate([seat_dia / 2, 0, window_z1])
    cube([col_dia / 2 - seat_dia / 2 + 1, window_w, window_z2 - window_z1 + 0.01]);
}