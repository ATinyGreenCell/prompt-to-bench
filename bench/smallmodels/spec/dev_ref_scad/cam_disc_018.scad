// Eccentric cam for shaker mechanism
// Print orientation: disc flat on bed (z = 0), hub builds upward.
// Shaft axis = Z axis (x = 0, y = 0); disc centre offset in +X.

// ---------------- Parameters ----------------
disc_d      = 40;   // cam disc diameter
disc_t      = 6;    // cam disc thickness (z = 0 .. 6)
eccentric   = 5;    // offset of disc centre from shaft axis (along X)
hub_d       = 14;   // hub diameter (on shaft axis)
hub_h       = 6;    // hub height above disc (z = 6 .. 12)
shaft_d     = 8;    // shaft hole diameter (through hub and disc)
eps         = 0.5;  // overcut for clean boolean differences
$fn         = 128;  // circle resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Eccentric disc
        translate([eccentric, 0, 0])
            cylinder(d = disc_d, h = disc_t);

        // Hub on shaft axis, overlapping slightly into disc for a solid union
        translate([0, 0, disc_t - 0.01])
            cylinder(d = hub_d, h = hub_h + 0.01);
    }

    // Shaft hole through hub and disc on the Z axis
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = disc_t + hub_h + 2 * eps);
}
