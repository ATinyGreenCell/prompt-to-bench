// Flat dial ring with radial tick marks for a rotary stage
// Units: mm. Print orientation: flat on bed, top face up.

$fn = 128;

// --- Ring dimensions ---
outer_d     = 80;    // outer diameter
inner_d     = 56;    // inner diameter (bore)
thickness   = 3;     // ring thickness (Z)

// --- Tick mark dimensions ---
tick_count  = 12;    // number of evenly spaced ticks
tick_width  = 1;     // groove width (tangential)
tick_depth  = 1.5;   // groove depth from top face
tick_length = 4;     // radial length inward from outer edge
tick_start_angle = 0; // first tick on +X axis

// --- Cutting overlap ---
eps = 0.5;           // extension past cut faces

outer_r = outer_d / 2;
inner_r = inner_d / 2;

difference() {
    // Annulus body
    difference() {
        cylinder(d = outer_d, h = thickness);
        translate([0, 0, -eps])
            cylinder(d = inner_d, h = thickness + 2 * eps);
    }

    // Radial tick grooves in top face
    for (i = [0 : tick_count - 1]) {
        rotate([0, 0, tick_start_angle + i * 360 / tick_count])
            translate([outer_r - tick_length,
                       -tick_width / 2,
                       thickness - tick_depth])
                cube([tick_length + eps, tick_width, tick_depth + eps]);
    }
}
