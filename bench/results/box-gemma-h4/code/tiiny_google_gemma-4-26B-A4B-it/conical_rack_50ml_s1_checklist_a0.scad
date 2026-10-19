// Rack for six 50 mL conical tubes
// Designed to be printed upside down (walls at Z=0 to Z=66) 
// and flipped to stand on the walls.

// --- Dimensions ---
plate_x      = 130.0; // Length of the plate (X)
plate_y      = 90.0;  // Width of the plate (Y)
plate_z      = 4.0;   // Thickness of the plate (Z)

hole_d       = 30.5;  // Diameter of the tube holes
rows         = 2;     // Number of rows along Y
cols         = 3;     // Number of columns along X
spacing_x    = 40.0;  // Center-to-center distance X
spacing_y    = 40.0;  // Center-to-center distance Y

wall_thick   = 4.0;   // Thickness of the side walls (Y direction)
wall_height  = 70.0;  // Total height from the base of the plate (Z)

$fn = 64;

// --- Calculations ---
// The user specifies the part is printed upside down.
// In print orientation (Z=0 is bed):
// The plate is at the top (Z = wall_height - plate_z to wall_height).
// The walls are at the bottom (Z = 0 to wall_height - plate_z).
// However, the prompt says: "a flat plate... 4mm thick lies on the bed (z=0 to 4)".
// And "Two solid walls... rises from the plate to z=70".
// This implies the plate is the base in the "printed" state, but the user says 
// "It is printed upside down and flipped over after printing."
// If it is printed upside down, the "top" of the final object (the plate) 
// is at Z=0 in the slicer.
// Let's follow the explicit Z-coordinates provided for the print orientation:
// Plate: Z = 0 to 4.
// Walls: Rise from plate to Z = 70.
// Total height = 70.

// --- Modeling ---

module rack() {
    difference() {
        // Main Body: Plate + Walls
        union() {
            // The Plate
            translate([-plate_x/2, -plate_y/2, 0])
                cube([plate_x, plate_y, plate_z]);
            
            // The Walls (along the long edges, flush with the edges)
            // Long edges are X direction (130mm).
            // Wall 1 at Y = -plate_y/2
            translate([-plate_x/2, -plate_y/2, plate_z])
                cube([plate_x, wall_thick, wall_height - plate_z]);
            
            // Wall 2 at Y = plate_y/2 - wall_thick
            translate([-plate_x/2, plate_y/2 - wall_thick, plate_z])
                cube([plate_x, wall_thick, wall_height - plate_z]);
        }

        // The Holes
        // Holes are centered on the plate.
        // X centers: 0, +/- 40
        // Y centers: +/- 20 (since spacing is 40 and they are centered)
        // Wait, if spacing is 40 and there are 2 rows, centers are at +/- 20.
        // If spacing is 40 and there are 3 columns, centers are at 0, +/- 40.
        
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                // Calculate offsets to center the grid
                let (
                    x_off = (i - (cols - 1) / 2) * spacing_x,
                    y_off = (j - (rows - 1) / 2) * spacing_y
                )
                translate([x_off, y_off, -1]) // Extend slightly to ensure clean cut
                    cylinder(h = plate_z + 2, d = hole_d);
            }
        }
    }
}

// Render the part
rack();