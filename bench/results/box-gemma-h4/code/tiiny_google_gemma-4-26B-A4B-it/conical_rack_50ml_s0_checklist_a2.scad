// 50mL Conical Tube Rack
// Designed for printing upside down (walls on bed)
// and flipped to stand on the walls.

// --- Dimensions ---
plate_x      = 130.0; // Length of the plate (X)
plate_y      = 90.0;  // Width of the plate (Y)
plate_z      = 4.0;   // Thickness of the plate (Z)

hole_d       = 30.5;  // Diameter of the tube holes
rows         = 2;     // Number of rows (along Y)
cols         = 3;     // Number of columns (along X)
spacing      = 40.0;  // Center-to-center distance between holes

wall_x       = 130.0; // Length of the side walls (X)
wall_y       = 4.0;   // Thickness of the side walls (Y)
wall_h       = 70.0;  // Total height of the walls from the base (Z)

$fn = 128; // Increased resolution for better diameter accuracy

// --- Calculations ---
x_offset = (cols - 1) * spacing / 2;
y_offset = (rows - 1) * spacing / 2;

module functional_rack() {
    difference() {
        union() {
            // The Base Plate
            translate([-plate_x/2, -plate_y/2, 0])
                cube([plate_x, plate_y, plate_z]);
            
            // The Two Side Walls
            // Wall 1 (along one long edge)
            translate([-plate_x/2, -plate_y/2, plate_z])
                cube([plate_x, wall_y, wall_h - plate_z]);
            
            // Wall 2 (along the other long edge)
            translate([-plate_x/2, plate_y/2 - wall_y, plate_z])
                cube([plate_x, wall_y, wall_h - plate_z]);
        }

        // The Six Holes
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                hx = (i * spacing) - x_offset;
                hy = (j * spacing) - y_offset;
                
                // Subtracting the hole. 
                // We use hole_d + 0.02 to ensure the diameter is at least 30.5
                // even with floating point/tessellation errors.
                translate([hx, hy, -1])
                    cylinder(h = plate_z + 2, d = hole_d + 0.02);
            }
        }
    }
}

// --- Print Orientation Logic ---
// Functional: Plate at Z=0, Walls up to Z=70.
// Print: Walls at Z=0, Plate at Z=66 to 70.
// To do this: 
// 1. Rotate 180 around X so plate is at top and walls are at bottom.
// 2. The part is now at Z = -70 to 0.
// 3. Translate by +70 in Z to bring it to Z = 0 to 70.

translate([0, 0, wall_h])
    rotate([180, 0, 0]) 
        functional_rack();