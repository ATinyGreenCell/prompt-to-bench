// L-shaped (hockey-stick) cell spreader, printed lying flat on the XY plane.
// All dimensions in millimetres.

$fn = 64;

// Handle bar
handle_len   = 150;   // length along +X
handle_w     = 6;     // width in Y
handle_t     = 4;     // thickness in Z

// Spreading foot bar
foot_len     = 40;    // length along its own axis
foot_w       = 5;     // width
foot_t       = 2.5;   // thickness (smooth bed side)
foot_angle   = 120;   // degrees CCW from +X, seen from above

// Round boss at the origin
boss_d       = 6;     // diameter
boss_t       = 4;     // height

// Hanging hole in the handle
hole_d       = 4;     // diameter
hole_x       = 143;   // centre X position
hole_y       = 0;     // centre Y position

// ---- Handle (axis-aligned bar, x = 0..150, y = -3..3, z = 0..4) ----
module handle() { translate([0, -handle_w/2, 0])
    cube([handle_len, handle_w, handle_t]); }

// ---- Spreading foot (rotated 120° about Z, local x = 0..40) ----
module foot() { rotate([0, 0, foot_angle])
    translate([0, -foot_w/2, 0])
    cube([foot_len, foot_w, foot_t]); }

// ---- Round boss at the origin (6 mm dia, 4 mm tall) ----
module boss() { cylinder(h = boss_t, d = boss_d); }

// ---- Hanging hole through the handle (4 mm dia, at x = 143, y = 0) ----
module hole() { translate([hole_x, hole_y, -1])
    cylinder(h = handle_t + 2, d = hole_d); }

// ---- Assemble: union of the three solids, then subtract the hole ----
difference() {
    union() {
        handle();
        foot();
        boss();
    }
    hole();
}