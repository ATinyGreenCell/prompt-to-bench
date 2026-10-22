// L-shaped (hockey-stick) cell spreader, printed flat on the XY plane.
// All dimensions in millimetres.

$fn = 64;

// Handle (long bar, +X direction)
handle_len   = 150;   // length along +X
handle_w     = 6;     // width in Y
handle_t     = 4;     // thickness in Z (0..4)

// Spreading foot (thin bar, 120 deg CCW from +X)
foot_len     = 40;    // length along its axis
foot_w       = 5;     // width in Y (local)
foot_t       = 2.5;   // thickness in Z (0..2.5)
foot_angle   = 120;   // degrees CCW from +X, seen from above

// Round boss at the origin joining the bars
boss_d       = 6;     // diameter
boss_t       = 4;     // height (0..4)

// Hanging hole through the handle
hole_d       = 4;     // diameter
hole_x       = 143;   // centre X position on the handle

// ---- Handle: x = 0..150, y = -3..3, z = 0..4 ----
module handle() { translate([0, -handle_w/2, 0])
    cube([handle_len, handle_w, handle_t]); }

// ---- Spreading foot: 40 mm bar rotated 120 deg about Z, z = 0..2.5 ----
// Centre line starts at origin and points 120 deg CCW from +X.
// Foot extends from origin along that direction for 40 mm.
module foot() { rotate([0, 0, foot_angle])
    translate([0, -foot_w/2, 0])
    cube([foot_len, foot_w, foot_t]); }

// ---- Round boss at the origin (centred on origin) ----
module boss() { cylinder(h = boss_t, d = boss_d, $fn = $fn); }

// ---- Hanging hole: 4 mm through the handle at x = 143, y = 0 ----
// Cut cylinder extends 1 mm past each face of the 4 mm-thick handle.
module hole() { translate([hole_x, 0, -1])
    cylinder(h = handle_t + 2, d = hole_d, $fn = $fn); }

// ---- Assemble: union of the three solids, then subtract the hole ----
difference() {
    union() {
        handle();
        foot();
        boss();
    }
    hole();
}