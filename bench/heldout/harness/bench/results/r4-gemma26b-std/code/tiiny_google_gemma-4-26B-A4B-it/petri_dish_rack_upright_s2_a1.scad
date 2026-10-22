// Petri Dish Rack for 10 dishes (90mm diameter)
// Corrected to ensure base is at Z=0 and cradle is cut into the base.

// --- Dimensions ---
base_length = 203;          // X dimension of the base
base_width = 80;            // Y dimension of the base
base_height = 20;           // Z dimension of the base

dish_radius = 45;           // Radius of 90mm dish
cradle_radius = 46;         // Radius of the cutting cylinder
cradle_z_offset = 52;       // Z-coordinate of the cylinder axis
// Note: Cradle bottom is at 52 - 46 = 6mm. Since base is 20mm, it cuts into the base.

num_dividers = 11;          // Number of solid divider plates
divider_thickness = 3;      // Thickness of each divider (X)
divider_height = 60;        // Height of dividers (Z)
divider_spacing_x = 20;     // Distance between divider centers (X)

// --- Constants ---
$fn = 64;

// --- Implementation ---

// The goal is to have a base with a groove, and dividers rising from Z=0.
// The dividers must NOT be cut by the cradle.
// The dividers must be part of the same solid or at least touch the bed at Z=0.

union() {
    // 1. The Base with the Cradle Cut
    // We use difference to cut the cylinder out of the base block.
    difference() {
        // The Base Block
        translate([-base_length/2, -base_width/2, 0])
            cube([base_length, base_width, base_height]);
        
        // The Cradle Cut
        // The cylinder axis is at Y=0, Z=52, running along X.
        // We translate the cylinder so its axis is at the correct Z.
        // Since cylinder is created on Z axis, we rotate it to X axis.
        translate([0, 0, cradle_z_offset])
        rotate([0, 90, 0])
            // We extend the cylinder length to ensure a clean cut through the base
            cylinder(h = base_length + 2, r = cradle_radius);
    }

    // 2. The Dividers
    // These rise from Z=0 to Z=60. 
    // Because they are in a union() with the base, they will be solid.
    // Because the cradle was subtracted from the base ONLY, the dividers remain solid.
    for (i = [0 : num_dividers - 1]) {
        // X positions: -100, -80, ..., 100
        x_pos = -100 + (i * divider_spacing_x);
        
        translate([x_pos - divider_thickness/2, -base_width/2, 0])
            cube([divider_thickness, base_width, divider_height]);
    }
}

// Verification of logic:
// - Base is at Z=0.
// - Dividers are at Z=0.
// - Cradle is subtracted from the base block, but since the dividers are 
//   added via union() AFTER the subtraction (or in a separate branch of the union),
//   the dividers remain solid and are not cut by the cylinder.
// - The cradle bottom is at Z = 52 - 46 = 6mm.
// - The base is 20mm tall. Thus, the cradle cuts a groove into the base.