// Eccentric cam for shaker mechanism
// Print orientation: disc flat on bed (z = 0), hub upward.
// Shaft axis = Z axis (origin). Disc centre offset in +X.

$fn = 128;

// --- Disc ---
disc_d      = 40;   // cam disc diameter
disc_t      = 5;    // cam disc thickness
eccentric   = 4;    // offset of disc centre from shaft axis (X)

// --- Hub ---
hub_d       = 16;   // hub diameter (on shaft axis)
hub_h       = 4;    // hub height above disc (z = 5 to 9)

// --- Shaft bore ---
bore_d      = 8;    // shaft hole diameter

// --- Misc ---
eps         = 0.5;  // overcut for clean boolean differences

difference() {
    union() {
        // Eccentric disc
        translate([eccentric, 0, 0])
            cylinder(d = disc_d, h = disc_t);

        // Hub on shaft axis (slightly overlaps disc for a solid union)
        translate([0, 0, disc_t - 0.01])
            cylinder(d = hub_d, h = hub_h + 0.01);
    }

    // Shaft bore through hub and disc
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = disc_t + hub_h + 2 * eps);
}
