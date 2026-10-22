// Petri Dish Rack for 10 dishes (90mm diameter)
// Corrected to ensure the cradle is cut into the base and dividers are solid.

// --- Dimensions ---
base_length = 203;          // X dimension of the base
base_width = 80;            // Y dimension of the base
base_height = 20;           // Z dimension of the base

dish_radius = 45;           // Radius of 90mm dish
cradle_radius = 46;         // Radius of the cutting cylinder
cradle_z_offset = 52;       // Z-coordinate of the cylinder axis
// Cradle bottom is at 52 - 46 = 6mm. Since base is 20mm, it cuts into the base.

num_dividers = 11;          // Number of solid divider plates
divider_thickness = 3;      // Thickness of each divider (X)
divider_height = 60;        // Height of dividers (Z)
divider_spacing_x = 20;     // Distance between divider centers (X)

// --- Constants ---
$fn = 64;

// --- Implementation ---

// The specification requires:
// 1. A base 203x80x20.
// 2. A cradle cut along the whole length of the base.
// 3. Eleven dividers (3mm thick) rising from Z=0 to Z=60.
// 4. The cradle is NOT cut through the dividers.

// To achieve this, we build the base with the cradle cut out, 
// then union the dividers on top.

union() {
    // Part 1: The Base with the cradle cut out
    difference() {
        // The Base Block
        translate([-base_length/2, -base_width/2, 0])
            cube([base_length, base_width, base_height]);
        
        // The Cradle Cut
        // The cylinder axis is at Y=0, Z=52, running along X.
        // We translate the cylinder so its axis is at the correct Z.
        // We use a large enough height to ensure it cuts through the base.
        translate([0, 0, cradle_z_offset])
        rotate([0, 90, 0])
            cylinder(h = base_length + 2, r = cradle_radius);
    }

    // Part 2: The Dividers
    // These rise from Z=0 to Z=60.
    // They are added via union, so they are not affected by the difference() above.
    for (i = [0 : num_dividers - 1]) {
        // X positions: -100, -80, ..., 100
        x_pos = -100 + (i * divider_spacing_x);
        
        translate([x_pos - divider_thickness/2, -base_width/2, 0])
            cube([divider_thickness, base_width, divider_height]);
    }
}

// Logic Verification:
// - Base is 203x80x20, centered on XY, starts at Z=0.
// - Cradle is a cylinder of radius 46, axis at Z=52. 
//   Bottom of cut = 52 - 46 = 6mm. 
//   Since base is 20mm, the cut is visible in the base.
// - Dividers are 3mm thick, 80mm wide, 60mm tall.
// - Dividers are placed at X = -100, -80... 100.
// - Because dividers are added via union() to the result of the difference(),
//   the cradle cut does not penetrate the dividers.