// L-shaped (hockey-stick) cell spreader, printed lying flat (z=0 is the bed side)
$fn = 64;

// Handle (long bar)
handle_len   = 150;   // mm, x = 0 to 150
handle_w     = 6;     // mm, y = -3 to 3
handle_t     = 4;     // mm, z = 0 to 4

// Spreading foot (thin bar, 120° CCW from +X)
foot_len     = 40;    // mm, along its centre line
foot_w       = 5;     // mm, transverse width
foot_t       = 2.5;   // mm, z = 0 to 2.5 (smooth bed side)
foot_angle   = 120;   // deg, CCW from +X, seen from above

// Round boss joining the bars at the origin
boss_d       = 6;     // mm diameter
boss_t       = 4;     // mm tall

// Hanging hole through the handle
hole_d       = 4;     // mm diameter
hole_x       = 143;   // mm, centre x position
hole_y       = 0;     // mm, centre y position

// ---- Handle: x 0..150, y -3..3, z 0..4 ----
module handle() { translate([-handle_len/2, -handle_w/2, 0])
    cube([handle_len, handle_w, handle_t]); }

// ---- Spreading foot: 40 mm bar, 120° CCW, z 0..2.5 ----
// Local frame: +x_local = 120° direction, +y_local = 120°+90° (transverse)
module foot() { rotate([0, 0, foot_angle])
    translate([-foot_len/2, -foot_w/2, 0])
    cube([foot_len, foot_w, foot_t]); }

// ---- Round boss at the origin ----
module boss() { cylinder(h = boss_t, d = boss_d); }

// ---- Hanging hole through the handle (extends past faces) ----
module hole() { translate([hole_x, hole_y, -1])
    cylinder(h = handle_t + 2, d = hole_d); }

// ---- Assemble: union of bars + boss, then subtract the hole ----
difference() {
    union() {
        handle();
        foot();
        boss();
    }
    hole();
}