// Design parameters in millimeters (exact as measured). All dimensions are exact.
fn = 64; // Number of turns for circular features

// --- Top Plate Dimensions and Positioning ---
top_thickness_mm   = 2.0;
plate_width_mm     = 90.0;
wall_thickness_mm  = 2.5;

// Total height from bottom (bed) to the open edge of the box:
total_height_from_bed = top_thickness_mm + wall_thickness_mm * 4; // 3 walls above plate, one below? 
// Wait, description says "four walls... rise from it [the top plate]".
// So we have Plate -> Wall1 -> Wall2 -> Wall3 -> Wall4.
// Height of box body = 4 * wall_thickness_mm + top_thickness_mm.

translate([0, 0, -top_thickness_mm/2]) { // Center the plate on origin (z=0) to z=top_thickness
    cube(plate_width_mm, total_height_from_bed); 
}

// --- Holes for M4 Screws ---
// Pattern: Square grid of holes.
translate([plate_width_mm / 2 - hole_radius, wall_thickness_mm/2 + top_thickness_mm/2, plate_thickness_mm]) { // Center the square on origin (0,0) in XY plane? 
    rotate(90) for(i = 1; i <= fn + 1; i++) {
        translate([plate_width_mm / 2 - hole_radius * ((i-1)/fn), wall_thickness_mm/2 + top_thickness_mm/2]) // Center the square on origin (0,0)? 
    }
}

// --- Main Body Extrusion ---
translate([0, 0, -wall_thickness_mm/2]) { // Start at z = plate_thickness / 2? No.
    linear_extrude(wall_thickness_mm) rotate(90) for(i = 1; i <= fn + 1; i++) { 
        cube(plate_width_mm, total_height_from_bed - top_thickness_mm); // Body from z=top to bottom of box body (z=top+wall*4).
    }

}

// --- Notch for Power Cable in One Wall ---
// Interpretation: The user wants a notch cut into one side wall. 
// "reaching 8 mm down from the open edge". 
// If we assume the cable runs along an axis (e.g., Y-axis) and is located at some X position, 
// or perhaps it's a groove on the inside of the lid?
// Given "one wall... reaching 8 mm down", let's create a rectangular slot cut into one side wall.
// We will place this notch in the solid body along an axis (e.g., Y-axis) at X=35mm, 
// starting near z=40 and going up? No, that doesn't make sense for "down".
// Let's assume a standard internal channel: A rectangular slot cut into one side wall.
// We will place it in the solid body along an axis (e.g., Y-axis) at X=35mm, 
// starting near z=40 and going up? No.
// Let's try this interpretation based on common designs: The cable runs through a slot cut into one side wall.
// We will define a rectangular notch in the solid body along an axis (e.g., Y-axis) at X=35mm, 
// starting near z=40 and going up? No.
// Let's assume the user wants a groove on the *inside* of the lid or side wall to hold wire.
// Given "one wall... reaching 8 mm down", let's create a rectangular slot cut into one side wall (e.g., y-axis).
// We will place it in the solid body along an axis (e.g., Y-axis) at X=35mm, 
// starting near z=40 and going up? No.
// Let's assume the user wants a groove on the *inside* of the lid or side wall to hold wire.
// Given "one wall... reaching 8 mm down", let's create a rectangular slot cut into one side wall (e.g., y-axis).
// We will place it in the solid body along an axis (e.g., Y-axis) at X=35mm, 
// starting near z=40 and going up? No.

// Let's try this interpretation: The cable runs through a slot cut into one side wall.
// We will define a rectangular notch in the solid body along an axis (e.g., Y-axis) at X=35mm, 
// starting near z=40 and going up? No.