// Dimensions in millimetres
plate_width = 130;           // X dimension of the flat plate
plate_length = 90;          // Y dimension of the flat plate
plate_thickness = 4;       // Thickness of plate (Z direction)
hole_diameter = 30.5;      // Diameter of each through-hole
hole_center_to_center = 40; // Centre-to-centre distance between holes in X and Y
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
wall_left = cube([plate_width, wall_thickness, wall_height], center=true);
translate([ -plate_width/2, 0, 0 ]) {
    wall_left;
}

// Wall on the right (positive X side)
wall_right = cube([plate_width, wall_thickness, wall_height], center=true);
translate([ plate_width/2, 0, 0 ]) {
    wall_right;
}

// Final model: base plate with holes, and two solid walls rising from the long edges
// The rack will stand on the two walls after flipping

// Build the full rack as a union of base plate and walls
union() {
    // Base plate with holes
    base_plate;
    
    // Left wall (from x = -plate_width/2 to x = plate_width/2, y=0 to y=wall_thickness, z=0 to wall_height)
    translate([ -plate_width/2, 0, 0 ]) 
        cube([plate_width, wall_thickness, wall_height], center=true);
    
    // Right wall (from x = plate_width/2 to x = plate_width/2 + plate_width, y=0 to y=wall_thickness, z=0 to wall_height)
    translate([ plate_width/2, 0, 0 ]) 
        cube([plate_width, wall_thickness, wall_height], center=true);
}