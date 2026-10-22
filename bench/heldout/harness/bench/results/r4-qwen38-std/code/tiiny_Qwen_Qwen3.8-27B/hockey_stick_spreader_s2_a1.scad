// L-shaped (hockey-stick) cell spreader, printed lying flat (z = 0 is the bed side).
// All dimensions in mm, taken directly from the user's caliper measurements.

$fn = 64;

// Handle bar
handle_len   = 150;   // length along +X
handle_w     = 6;     // width in Y
handle_t     = 4;     // thickness in Z (z = 0..4)

// Spreading foot bar
foot_len     = 40;    // length along its own axis
foot_w       = 5;     // width in Y (local)
foot_t       = 2.5;   // thickness in Z (z = 0..2.5, smooth bed side)
foot_angle   = 120;   // CCW from +X, seen from above; foot & handle make 120°

// Round boss at the origin joining the bars
boss_d       = 6;     // diameter
boss_t       = 4;     // height (z = 0..4)

// Hanging hole through the handle
hole_d       = 4;     // diameter
hole_x       = 143;   // centre x
hole_y       = 0;     // centre y

// ---- Handle (axis-aligned box, x = 0..150, y = -3..3, z = 0..4) ----
handle = translate([-handle_len/2, -handle_w/2, 0])
    cube([handle_len, handle_w, handle_t]);

// ---- Spreading foot (local box, then rotated 120° about Z at the origin) ----
foot = rotate([0, 0, foot_angle])
    translate([-foot_len/2, -foot_w/2, 0])
    cube([foot_len, foot_w, foot_t]);

// ---- Round boss at the origin (z = 0..4) ----
boss = cylinder(h = boss_t, d = boss_d, $fn = $fn);

// ---- Hanging hole (through the handle, centred at x = 143, y = 0) ----
// Cut cylinder extends 1 mm past the top face (z = 4) and 1 mm below the bed (z = 0)
// so no faces are exactly coplanar with the handle.
hole = translate([hole_x, hole_y, -1])
    cylinder(h = handle_t + 2, d = hole_d, $fn = $fn);

// ---- Assemble: union the three solids, then subtract the hanging hole ----
difference() {
    union() {
        handle;
        foot;
        boss;
    }
    hole;
}