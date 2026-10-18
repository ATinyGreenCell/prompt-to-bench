// DIY magnetic stirrer housing (print orientation: top plate down, open box up)
// Units: mm

$fn = 64;

// --- Box dimensions ---
outer_x   = 90;    // outer size in X
outer_y   = 90;    // outer size in Y
top_t     = 2;     // top plate thickness (z = 0 to 2)
wall_t    = 2.5;   // wall thickness (z = 2 to 40)
box_h     = 40;    // top of walls (z)
notch_w   = 12;    // cable notch width
notch_d   = 8;     // cable notch depth from open edge (z = 32 to 40)

// --- Screw holes ---
screw_d   = 4.5;   // M4 hole diameter
screw_n   = 4;     // number of holes
screw_p   = 71.5;  // square pattern pitch (centred)

// --- Cutting overlap ---
eps       = 0.5;   // extension past cut faces

difference() {
    // Solid box
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, top_t]);
        // Walls (slightly overlapping the plate for a clean union)
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_x/2 - wall_t : -outer_x/2,
                       sy > 0 ? outer_y/2 - wall_t : -outer_y/2,
                       0])
                cube([2*wall_t, 2*wall_t, box_h]);
    }

    // Screw holes through top plate
    for (i = [0 : screw_n - 1]) {
        x = (i - (screw_n - 1)/2) * screw_p;
        y = (i - (screw_n - 1)/2) * screw_p;
        translate([x, y, -eps])
            cylinder(d = screw_d, h = top_t + 2*eps);
    }

    // Cable notch in one wall (from open edge down to z = 32)
    translate([outer_x/2 - wall_t - notch_w/2, -notch_w/2, box_h - notch_d])
        cube([notch_w, notch_w, notch_d + eps]);
}