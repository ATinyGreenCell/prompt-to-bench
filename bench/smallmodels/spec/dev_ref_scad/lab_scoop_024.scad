// Powder measuring scoop - hemispherical bowl with flat handle
// Print orientation: bowl opening up, bottom of bowl touching bed at z = 0

$fn = 96;

// ---------- Bowl ----------
bowl_r_out   = 15;          // outer radius of bowl sphere
bowl_wall    = 2;           // wall thickness
bowl_r_in    = bowl_r_out - bowl_wall; // inner radius (13)
bowl_cz      = 15;          // sphere centre height (rim plane)

// ---------- Handle ----------
handle_w     = 10;          // width in Y
handle_t     = 3;           // thickness in Z
handle_x0    = 13;          // start of handle in X
handle_x1    = 115;         // end of handle in X
handle_ztop  = bowl_cz;     // top face flush with rim (z = 15)

eps = 0.5;                  // cutter overlap

module bowl() {
    difference() {
        translate([0, 0, bowl_cz]) sphere(r = bowl_r_out);
        // hollow interior (extends through rim plane)
        translate([0, 0, bowl_cz]) sphere(r = bowl_r_in);
        // remove upper half
        translate([-bowl_r_out - eps, -bowl_r_out - eps, bowl_cz])
            cube([2 * (bowl_r_out + eps), 2 * (bowl_r_out + eps), bowl_r_out + eps]);
    }
}

module handle() {
    translate([handle_x0, -handle_w / 2, handle_ztop - handle_t])
        cube([handle_x1 - handle_x0, handle_w, handle_t]);
}

difference() {
    union() {
        bowl();
        handle();
    }
    // keep the bowl cavity clear of any handle material
    translate([0, 0, bowl_cz]) sphere(r = bowl_r_in);
}
