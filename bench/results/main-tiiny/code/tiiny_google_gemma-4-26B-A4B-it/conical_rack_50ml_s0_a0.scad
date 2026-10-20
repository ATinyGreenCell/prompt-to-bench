// --- Dimensions (mm) ---
plate_width = 130;          // X dimension of the base plate
plate_depth = 90;           // Y dimension of the base plate
plate_thickness = 4;        // Thickness of the base plate
wall_height = 70;           // Height of the side walls from the plate
wall_thickness = 4;         // Thickness of the side walls
hole_diameter = 30.5;       // Diameter of the tube holes
hole_spacing_x = 40;        // Center-to-center distance along X
hole_spacing_y = 40;        // Center-to-center distance along Y
num_holes_x = 3;            // Number of holes along X axis
num_holes_y = 2;            // Number of holes along Y axis

// --- Resolution ---
$fn = 64;

// --- Construction ---

// The part is designed to be printed "upside down" relative to its final use.
// In print orientation: 
// The plate is at Z=0 to Z=4.
// The walls rise from Z=4 to Z=70.
// The holes are cut through the plate.

module tube_rack() {
    difference() {
        // Main Body: The plate and the two side walls
        union() {
            // The Base Plate
            cube([plate_width, plate_depth, plate_thickness]);
            
            // Wall 1 (along one long edge)
            translate([0, 0, plate_thickness])
                cube([plate_width, wall_thickness, wall_height]);
            
            // Wall 2 (along the other long edge)
            translate([0, plate_depth - wall_thickness, plate_thickness])
                cube([plate_width, wall_thickness, wall_height]);
        }

        // The Holes
        // We calculate the starting position to center the grid on the plate
        // Grid center is at (plate_width/2, plate_depth/2)
        // Offset calculation: (Total_spacing - (count-1)*spacing) / 2
        
        start_x = (plate_width - (num_holes_x - 1) * hole_spacing_x) / 2;
        start_y = (plate_depth - (num_holes_y - 1) * hole_spacing_y) / 2;

        for (i = [0 : num_holes_x - 1]) {
            for (j = [0 : num_holes_y - 1]) {
                translate([
                    start_x + i * hole_spacing_x, 
                    start_y + j * hole_spacing_y, 
                    -0.01 // Slight overlap to ensure clean cut through bottom
                ])
                cylinder(d = hole_diameter, h = plate_thickness + 0.02);
            }
        }
    }
}

// Render the part
tube_rack();