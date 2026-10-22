// Flat dial ring with radial tick marks for a rotary stage
// Units: mm. Print orientation: flat on bed, top face up.

$fn = 128;

// --- Ring dimensions ---
outer_d      = 70;    // outer diameter
inner_d      = 50;    // inner diameter
ring_h       = 3;     // ring thickness

// --- Tick marks ---
tick_count   = 12;    // number of evenly spaced ticks
tick_width   = 1;     // groove width
tick_depth   = 1.5;   // groove depth from top face
tick_length  = 4;     // radial length inward from outer edge
tick_start   = 0;     // angle of first tick (deg, +X axis)

// --- Clearance for clean booleans ---
eps          = 0.5;   // overshoot past cut faces

outer_r = outer_d / 2;
inner_r = inner_d / 2;

difference() {
    // Annulus
    difference() {
        cylinder(h = ring_h, r = outer_r);
        translate([0, 0, -eps])
            cylinder(h = ring_h + 2 * eps, r = inner_r);
    }

    // Radial tick grooves
    for (i = [0 : tick_count - 1]) {
        rotate([0, 0, tick_start + i * 360 / tick_count])
            translate([outer_r - tick_length,
                       -tick_width / 2,
                       ring_h - tick_depth])
                cube([tick_length + eps,
                      tick_width,
                      tick_depth + eps]);
    }
}
