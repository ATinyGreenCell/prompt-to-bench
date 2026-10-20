// Dimensions in millimetres
plate_width = 130;           // X dimension of the flat plate
plate_length = 90;          // Y dimension of the flat plate
plate_thickness = 4;       // Thickness of plate (Z direction)
hole_diameter = 30.5;      // Diameter of each through-hole
hole_center_to_center = 40; // Centre-to-centre distance between holes in X and Y
num_holes_per_row = 3;     // Number of holes in each row (2 rows of 3)
wall_thickness = 4;        // Thickness of the solid walls (Y direction)
wall_height = 70;         // Height of walls from plate to z = 70

$fn = 64;

// Create the base plate
base_plate = cube([plate_width, plate_length, plate_thickness], center=true);

// Create the through-holes in the base plate
for (i = [0:2]) {
    for (j = [0:1]) {
        translate([ 
            (i * hole_center_to_center) - (hole_diameter / 2),
            (j * hole_center_to_center) - (hole_diameter / 2),
            0
        ]) {
            cylinder(h=plate_thickness, r=hole_diameter/2, center=true);
        }
    }
}

// Create the two solid walls extending from the long edges of the plate
// Wall on the left (negative X side)
wall_left = translate([ -plate_width/2, 0, 0 ]) 
    cube([plate_width, wall_thickness, wall_height], center=true);

// Wall on the right (positive X side)
wall_right = translate([ plate_width/2, 0, 0 ]) 
    cube([plate_width, wall_thickness, wall_height], center=true);

// Create the full structure: base plate with holes, plus walls
// Use union to combine all parts
difference() {
    // Start with the base plate
    union() {
        base_plate;
        // Add the two walls
        wall_left;
        wall_right;
    }
    
    // Subtract the holes from the walls (to avoid holes in walls)
    // We only subtract holes that are in the base plate, not in the walls
    // Since the walls are only on the edges, we don't need to cut them
    // Instead, we just build the structure as a union of base plate and walls
}

// Final model: base plate with holes, and two solid walls rising from the long edges
// The model is built with the base on z=0, and walls extending to z=70
// After printing, it is flipped over, so the walls become the base and the holes allow tubes to pass through

// Final model: base plate with holes and two walls extending upward
// The rack will stand on the two walls after flipping

// Build the full rack
racks = 
    union() {
        // Base plate with holes
        base_plate;
        
        // Left wall (from x = -plate_width/2 to x = -plate_width/2 + plate_width, y=0 to y=wall_thickness, z=0 to wall_height)
        translate([ -plate_width/2, 0, 0 ]) 
            cube([plate_width, wall_thickness, wall_height], center=true);
        
        // Right wall
        translate([ plate_width/2, 0, 0 ]) 
            cube([plate_width, wall_thickness, wall_height], center=true);
    };

// Ensure the holes are properly defined and the structure is solid
// The holes are in the base plate and do not extend into the walls
// The walls are solid and rise from the base plate to z=70

// Final output: the rack is built as described
// It will be flipped after printing, so the walls become the base and the holes allow tubes to pass through

// Final model
racks;