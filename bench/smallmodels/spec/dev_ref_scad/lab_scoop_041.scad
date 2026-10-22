// Powder measuring scoop - hemispherical bowl with flat handle
// Print orientation: bowl bottom on bed (z = 0), opening upward

$fn = 96;

// ---- Bowl ----
bowl_outer_r = 12;                    // outer radius of bowl sphere
bowl_wall    = 2;                     // bowl wall thickness
bowl_inner_r = bowl_outer_r - bowl_wall; // inner (cavity) radius
bowl_cz      = 12;                    // sphere centre height (rim plane)

// ---- Handle ----
handle_x0    = 10;                    // handle start (X)
handle_x1    = 72;                    // handle end (X)
handle_w     = 12;                    // handle width (Y)
handle_t     = 4;                     // handle thickness (Z)
handle_ztop  = 12;                    // handle top face, flush with rim

eps = 0.5;                            // cutter overshoot

difference() {
    union() {
        // Lower half of outer sphere
        intersection() {
            translate([0, 0, bowl_cz]) sphere(r = bowl_outer_r);
            translate([-bowl_outer_r - eps, -bowl_outer_r - eps, -eps])
                cube([2 * (bowl_outer_r + eps),
                      2 * (bowl_outer_r + eps),
                      bowl_cz + eps]);
        }
        // Flat handle
        translate([handle_x0, -handle_w / 2, handle_ztop - handle_t])
            cube([handle_x1 - handle_x0, handle_w, handle_t]);
    }
    // Bowl cavity (also keeps the handle out of the cavity)
    translate([0, 0, bowl_cz]) sphere(r = bowl_inner_r);
}
