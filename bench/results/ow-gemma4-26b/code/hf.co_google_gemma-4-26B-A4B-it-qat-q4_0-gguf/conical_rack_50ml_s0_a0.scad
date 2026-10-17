// --- Dimensions (mm) ---
plate_width = 130;       // X dimension of the plate
plate_depth = 90;        // Y dimension of the plate
plate_thickness = 4;     // Z dimension of the plate
wall_height = 70;        // Height of the side walls (Z)
wall_thickness = 4;      // Thickness of the side walls (Y)

hole_diameter = 30.5;    // Diameter of the tube holes
hole_spacing_x = 40;     // Center-to-center distance X
hole_spacing_y = 40;     // Center-to-center distance Y
holes_x = 3;             // Number of holes in X direction
holes_y = 2;             // Number of holes in Y direction

// --- Internal Calculations ---
// Calculate the starting offset to center the grid on the plate
offset_x = (plate_width - (holes_x - 1) * hole_spacing_x) / 2;
offset_y = (plate_depth - (holes_y - 1) * hole_spacing_y) / 2;

// Resolution
$fn = 64;

// --- Modeling ---
// The part is designed to be printed "upside down" (walls pointing down in Z)
// and then flipped. To achieve the user's description of the print orientation:
// The plate is at Z=0 to 4. The walls rise from the plate to Z=70.
// This means the walls are printed "upwards" from the bed.
// To print "upside down" as requested, we model it as described, 
// but the user's instruction implies the final standing orientation 
// is the result of flipping the print.

union() {
    // 1. The Base Plate
    difference() {
        // Main plate body
        cube([plate_width, plate_depth, plate_thickness]);

        // 2. The Six Holes
        // We use a nested loop to create the 3x2 grid
        for (i = [0 : holes_x - 1]) {
            for (j = [0 : holes_y - 1]) {
                translate(
                    [offset_x + i * hole_spacing_x, 
                     offset_y + j * hole_spacing_y, 
                     -1] // Extend slightly below plate
                )
                cylinder(h = plate_thickness + 2, d = hole_diameter);
            }
        }
    }

    // 3. The Two Side Walls
    // Walls are flush with the long edges (X-axis edges)
    // Long edges are at Y = 0 and Y = plate_depth
    
    // Wall 1 (at Y = 0)
    translate([0, 0, plate_thickness])
    cube([plate_width, wall_thickness, wall_height]);

    // Wall 2 (at Y = plate_depth - wall_thickness)
    // Note: To be "flush with the long edge" and 4mm thick, 
    // the wall occupies the space from Y = plate_depth - 4 to plate_depth.
    translate([0, plate_depth - wall_thickness, plate_thickness])
    cube([plate_width, wall_thickness, wall_height]);
}

// Note on Orientation:
// The model is built with the plate at Z=0.
// The walls extend from Z=4 to Z=74.
// When printed, the plate sits on the bed. 
// The user's instruction "It is printed upside down and flipped over" 
// suggests the user wants the walls to be the contact points 
// when standing, which is achieved by the geometry described.