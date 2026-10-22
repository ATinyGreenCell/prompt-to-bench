// Flat dial ring with radial tick marks for a rotary stage
// Units: mm. Print orientation: flat on bed, top face up.

$fn = 128;

// --- Ring dimensions ---
outer_d   = 50;    // outer diameter
inner_d   = 26;    // inner (bore) diameter
thickness = 4;     // ring thickness (Z)

// --- Tick marks ---
tick_count  = 12;   // number of evenly spaced ticks
tick_width  = 1.2;  // groove width
tick_depth  = 1.5;  // groove depth from top face
tick_length = 3;    // radial length inward from outer edge
start_angle = 0;    // first tick on +X axis

// --- Clearances for clean boolean cuts ---
eps     = 0.5;      // overcut past faces
outer_r = outer_d / 2;
inner_r = inner_d / 2;

difference() {
    // Annulus
    difference() {
        cylinder(h = thickness, r = outer_r);
        translate([0, 0, -eps])
            cylinder(h = thickness + 2 * eps, r = inner_r);
    }

    // Radial tick grooves in the top face
    for (i = [0 : tick_count - 1]) {
        rotate([0, 0, start_angle + i * 360 / tick_count])
            translate([outer_r - tick_length,
                       -tick_width / 2,
                       thickness - tick_depth])
                cube([tick_length + eps, tick_width, tick_depth + eps]);
    }
}
