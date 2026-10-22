// Eccentric cam for shaker mechanism
// Print orientation: disc flat on bed (z = 0), hub upward.
// Shaft axis = Z axis (x = 0, y = 0); disc centre offset in +X.

$fn = 96;

// --- Dimensions (mm) ---
disc_d      = 30;   // cam disc diameter
disc_t      = 8;    // cam disc thickness
eccentric   = 5;    // offset of disc centre from shaft axis (along X)
hub_d       = 11;   // hub diameter (on shaft axis)
hub_h       = 6;    // hub height above disc (z = 8 to 14)
shaft_d     = 5;    // shaft bore diameter
eps         = 0.5;  // overcut for clean differences

difference() {
    union() {
        // Eccentric disc
        translate([eccentric, 0, 0])
            cylinder(d = disc_d, h = disc_t);

        // Hub on shaft axis, overlapping the disc slightly for a solid union
        translate([0, 0, disc_t - 0.01])
            cylinder(d = hub_d, h = hub_h + 0.01);
    }

    // Shaft bore through hub and disc
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = disc_t + hub_h + 2 * eps);
}
