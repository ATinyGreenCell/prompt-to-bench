// Powder measuring scoop - hemispherical bowl with flat handle
// Print orientation: bowl bottom on bed (z = 0), opening upward

$fn = 96;

// ---------------- Parameters ----------------
bowl_outer_r   = 12;     // outer radius of the hemispherical bowl
bowl_wall      = 1.5;    // bowl wall thickness
bowl_inner_r   = bowl_outer_r - bowl_wall; // inner (cavity) radius = 10.5
bowl_center_z  = 12;     // sphere centre height (rim plane)

handle_x_start = 10.5;   // handle start along +X
handle_x_end   = 92;     // handle end along +X
handle_width   = 8;      // handle width in Y
handle_thick   = 4;      // handle thickness in Z
handle_top_z   = bowl_center_z;               // top face flush with rim
handle_bot_z   = handle_top_z - handle_thick; // = 8

eps = 0.5;               // overlap for clean boolean cuts

// ---------------- Model ----------------
difference() {
    union() {
        // Solid outer lower hemisphere
        difference() {
            translate([0, 0, bowl_center_z])
                sphere(r = bowl_outer_r);
            // remove upper half
            translate([-bowl_outer_r - eps, -bowl_outer_r - eps, bowl_center_z])
                cube([2 * (bowl_outer_r + eps), 2 * (bowl_outer_r + eps), bowl_outer_r + eps]);
        }

        // Flat handle
        translate([handle_x_start, -handle_width / 2, handle_bot_z])
            cube([handle_x_end - handle_x_start, handle_width, handle_thick]);
    }

    // Bowl cavity (also keeps handle out of the cavity)
    translate([0, 0, bowl_center_z])
        sphere(r = bowl_inner_r);
}
