// Eccentric cam for shaker mechanism
// Shaft axis = Z axis (x=0, y=0). Disc is offset in +X.

$fn = 96;

// ---- Dimensions (mm) ----
disc_d      = 30;   // cam disc diameter
disc_t      = 8;    // cam disc thickness (z = 0 .. 8)
eccentric   = 6;    // disc centre offset from shaft axis, along +X
hub_d       = 12;   // hub diameter (on shaft axis)
hub_h       = 5;    // hub height above disc (z = 8 .. 13)
shaft_d     = 6;    // shaft hole diameter
eps         = 0.5;  // overshoot for clean boolean cuts
overlap     = 0.01; // small overlap so hub fuses with disc

total_h = disc_t + hub_h;

difference() {
    union() {
        // Eccentric disc
        translate([eccentric, 0, 0])
            cylinder(d = disc_d, h = disc_t);

        // Hub on shaft axis
        translate([0, 0, disc_t - overlap])
            cylinder(d = hub_d, h = hub_h + overlap);
    }

    // Shaft hole through hub and disc
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = total_h + 2 * eps);
}
