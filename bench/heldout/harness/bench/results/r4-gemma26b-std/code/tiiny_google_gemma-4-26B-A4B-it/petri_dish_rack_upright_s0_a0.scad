// --- Dimensions ---
base_length = 203;          // X dimension of the base
base_width = 80;            // Y dimension of the base
base_height = 20;           // Z dimension of the base

dish_radius = 46;           // Radius of the cylinder used to cut the cradle
cradle_z_center = 52;       // Z coordinate of the cylinder axis
cradle_offset = 1;          // Extra length for cutting operations

divider_thickness = 3;       // Thickness of each divider plate
divider_height = 60;        // Height of each divider plate
divider_count = 11;          // Number of divider plates
divider_spacing_x = 20;      // Distance between divider centers

// --- Parameters ---
$fn = 64;

// --- Main Assembly ---

union() {
    // 1. The Base Block
    cube([base_length, base_width, base_height], center = true);

    // 2. The Divider Plates
    // We use a loop to place 11 dividers from -100 to 100 in steps of 20
    for (i = [0 : divider_count - 1]) {
        // Calculate X position: starts at -100, ends at 100
        // Formula: -100 + (i * 20)
        x_pos = -100 + (i * divider_spacing_x);
        
        translate([x_pos, 0, divider_height / 2])
            cube([divider_thickness, base_width, divider_height], center = true);
    }
}

// 3. The Cradle Cutout
// The cradle is a cylinder running along the X axis.
// We subtract this from the union of the base and dividers.
difference() {
    // We wrap the previous union in a difference to cut the cradle out of everything
    // However, to follow the instruction "the cradle is not cut through them" 
    // (meaning the dividers remain solid), we must only subtract the cradle 
    // from the base and the parts of the dividers that intersect the cradle.
    // But the prompt says "the cradle is not cut through them" referring to the dividers.
    // This implies the dividers are solid vertical walls, and the cradle is a groove 
    // cut into the base and potentially the dividers, but the user says 
    // "the cradle is not cut through them". 
    // Re-reading: "Eleven solid divider plates... rise from z=0 to z=60... the cradle is not cut through them."
    // This means the dividers are continuous from z=0 to z=60, and the cradle 
    // only affects the base block.
    
    // Let's refine the logic: 
    // Part A: Base with cradle cut out.
    // Part B: 11 Dividers.
    // Result: Part A + Part B.
    
    // To achieve this cleanly in OpenSCAD:
    // We will define the base separately and subtract the cylinder from it.
    // Then we add the dividers.
    
    // Wait, the prompt says "A curved cradle... is cut along its whole length".
    // If the cradle is not cut through the dividers, the dividers act as 
    // full-height walls and the cradle is a groove in the base.
    
    // Let's build the base with the groove first.
    // (This code block is inside the difference, so we need to structure the whole file correctly)
}

// --- Corrected Structure to respect "cradle is not cut through them" ---

// We will use a union of the base and dividers, but we need to subtract the cradle 
// ONLY from the base. The easiest way is to create the base with the groove, 
// then add the dividers.

module base_with_groove() {
    difference() {
        // The base block
        cube([base_length, base_width, base_height], center = true);
        
        // The cradle cylinder
        // Axis runs along X, so we rotate the cylinder
        translate([0, 0, cradle_z_center])
            rotate([0, 90, 0])
                cylinder(h = base_length + cradle_offset * 2, r = dish_radius, center = true);
    }
}

module dividers() {
    for (i = [0 : divider_count - 1]) {
        x_pos = -100 + (i * divider_spacing_x);
        translate([x_pos, 0, divider_height / 2])
            cube([divider_thickness, base_width, divider_height], center = true);
    }
}

// Final Render
union() {
    base_with_groove();
    dividers();
}

// Note: The prompt says "the cradle is not cut through them [the dividers]".
// This means the dividers are 60mm tall and solid. 
// The cradle is a groove cut into the base.
// Since the base is only 20mm tall and the cradle axis is at z=52 with radius 46,
// the bottom of the cradle is at 52 - 46 = 6mm.
// Since the base is 20mm tall (from z=-10 to z=10), the cradle (bottom at z=6)
// will indeed cut into the top of the base.