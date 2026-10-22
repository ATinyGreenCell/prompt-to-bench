// Powder measuring scoop - hemispherical bowl with flat handle
// Print orientation: bowl bottom touches bed at z = 0, opening upward

// ---------------- Parameters ----------------
bowl_outer_r   = 10;      // outer radius of bowl sphere
bowl_wall      = 1.5;     // bowl wall thickness
bowl_inner_r   = bowl_outer_r - bowl_wall; // inner radius (8.5)
bowl_center_z  = 10;      // sphere centre height (rim height)

handle_x_start = 8.5;     // handle starts at x = 8.5
handle_x_end   = 110;     // handle ends at x = 110
handle_width   = 10;      // handle width along Y
handle_thick   = 4;       // handle thickness along Z
handle_top_z   = bowl_center_z;             // top flush with rim
handle_bot_z   = handle_top_z - handle_thick; // z = 6

eps            = 0.5;     // overcut for clean differences
$fn            = 128;     // smoothness of curved surfaces

// ---------------- Model ----------------
difference() {
    union() {
        // Solid lower hemisphere (outer shell)
        intersection() {
            translate([0, 0, bowl_center_z])
                sphere(r = bowl_outer_r);
            translate([-bowl_outer_r - eps, -bowl_outer_r - eps, -eps])
                cube([2 * (bowl_outer_r + eps),
                      2 * (bowl_outer_r + eps),
                      bowl_center_z + eps]);   // keep z <= 10
        }

        // Flat handle
        translate([handle_x_start, -handle_width / 2, handle_bot_z])
            cube([handle_x_end - handle_x_start, handle_width, handle_thick]);
    }

    // Hollow out the bowl (full sphere extends above rim, opening it)
    translate([0, 0, bowl_center_z])
        sphere(r = bowl_inner_r);
}
