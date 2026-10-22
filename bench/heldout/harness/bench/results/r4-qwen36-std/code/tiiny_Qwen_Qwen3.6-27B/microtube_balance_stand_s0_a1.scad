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
// The previous code used a cube which did not account for the hole inside the seat.
// We need to cut a slot that goes from the outer surface to the inner seat surface.
// The seat radius is seat_dia/2 = 5.5mm.
// The column radius is col_dia/2 = 11mm.
// The window is on the +X side.
// We create a difference to cut the window.

difference() {
    // Union of all solid parts
    union() {
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
        translate([0, 0, tip_z])
          cylinder(h = cone_seat_h, r1 = tip_dia / 2, r2 = seat_dia / 2, center = false);
    }

    // Cut out the viewing window
    // The window is a slot on the +X side.
    // It spans Y from -window_w/2 to +window_w/2.
    // It spans Z from window_z1 to window_z2.
    // It spans X from the inner seat radius to the outer column radius + margin.
    // Inner radius = seat_dia/2 = 5.5
    // Outer radius = col_dia/2 = 11
    // We extend the cut slightly past the outer surface to ensure clean cut.
    
    translate([seat_dia / 2, -window_w / 2, window_z1])
      cube([col_dia / 2 - seat_dia / 2 + 1, window_w, window_z2 - window_z1 + 0.02]);
}