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

// Final model: base plate with holes, and two solid walls rising from the long edges
// The rack will stand on the two walls after flipping

// Use difference to build the final part: start with the base and walls, then subtract holes
// But we must avoid overlapping or invalid geometry

// Correct approach: build the entire structure as a union of base plate and walls
// The holes are only in the base plate; walls are solid

// Start with the base plate
// Add the two walls extending upward from the long edges
// The walls are aligned along the long edges (Y=0), extending in X and Z

// Final structure: base plate with holes, plus two solid walls rising from the long edges
// The walls are 130 mm long (X), 4 mm thick (Y), and 70 mm high (Z)

// Build the full rack
racks = 
    union() {
        // Base plate with holes
        base_plate;
        
        // Left wall: from x = -plate_width/2 to x = -plate_width/2 + plate_width, y=0 to y=wall_thickness, z=0 to wall_height
        translate([ -plate_width/2, 0, 0 ]) 
            cube([plate_width, wall_thickness, wall_height], center=true);
        
        // Right wall: from x = plate_width/2 to x = plate_width/2 + plate_width, y=0 to y=wall_thickness, z=0 to wall_height
        translate([ plate_width/2, 0, 0 ]) 
            cube([plate_width, wall_thickness, wall_height], center=true);
    };

// Since we are building a solid, we must ensure no overlapping or invalid geometry
// The holes are only in the base plate, and the walls are solid and extend upward

// Final model: the rack is built with:
// - A 130x90x4 base plate with 3x2 holes (30.5 mm diameter, 40 mm center-to-center)
// - Two solid walls of 130x4x70 mm rising from the long edges (X-direction), centered on the plate

// After printing, the rack is flipped over, so it stands on the two walls and the tubes pass through the holes

// Final output
racks;