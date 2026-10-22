// Flat dial ring with radial tick marks for a rotary stage
// Units: mm. Print orientation: flat on bed, top face up.

$fn = 128;

// --- Ring dimensions ---
outer_d   = 60;    // outer diameter of annulus
inner_d   = 44;    // inner diameter of annulus
thickness = 4;     // ring thickness (Z)

// --- Tick mark dimensions ---
tick_count  = 24;   // number of evenly spaced ticks
tick_width  = 1.2;  // groove width
tick_depth  = 1.5;  // groove depth from top face
tick_length = 3;    // radial length inward from outer edge

// --- Helpers ---
eps = 0.5;          // overshoot for clean boolean cuts
outer_r = outer_d / 2;
inner_r = inner_d / 2;

difference() {
    // Annulus body
    difference() {
        cylinder(h = thickness, r = outer_r);
        translate([0, 0, -eps])
            cylinder(h = thickness + 2 * eps, r = inner_r);
    }

    // Radial tick grooves, first on +X axis
    for (i = [0 : tick_count - 1]) {
        rotate([0, 0, i * 360 / tick_count])
            translate([outer_r - tick_length,
                       -tick_width / 2,
                       thickness - tick_depth])
                cube([tick_length + eps,          // overshoot past outer edge
                      tick_width,
                      tick_depth + eps]);          // overshoot above top face
    }
}
