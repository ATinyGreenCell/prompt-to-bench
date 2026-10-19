// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions: 106mm (X) x 72mm (Y) x 30mm (Z)
// Features: 24 holes (6x4 grid), 16mm spacing, 11.2mm diameter, 25mm depth

// --- Dimensions ---
length_x = 106.0;    // Total length along X axis
width_y  = 72.0;     // Total width along Y axis
height_z = 30.0;     // Total height along Z axis

holes_x  = 6;        // Number of holes along X
holes_y  = 4;        // Number of holes along Y
spacing  = 16.0;     // Center-to-center distance between holes
hole_dia = 11.2;     // Diameter of the tube holes
hole_depth = 25.0;   // Depth of the holes from the top surface

$fn = 64;            // Smoothness for cylinders

// --- Calculations ---
// The grid is centered on the block. 
// The offset for the first hole in the loop is calculated to ensure symmetry.
// For 6 holes with 16mm spacing, the span is (6-1)*16 = 80mm.
// For 4 holes with 16mm spacing, the span is (4-1)*16 = 48mm.

module tube_rack() {
    difference() {
        // The main block
        translate([-length_x/2, -width_y/2, 0])
            cube([length_x, width_y, height_z]);

        // The holes
        // We use a nested loop to create the 6x4 grid
        for (i = [0 : holes_x - 1]) {
            for (j = [0 : holes_y - 1]) {
                // Calculate X position: centered grid
                // (i - (total-1)/2) * spacing
                let (x_pos = (i - (holes_x - 1) / 2) * spacing)
                // Calculate Y position: centered grid
                let (y_pos = (j - (holes_y - 1) / 2) * spacing)
                
                translate([x_pos, y_pos, height_z - hole_depth + 0.01]) // +0.01 to ensure clean cut through top
                    cylinder(d = hole_dia, h = hole_depth + 0.01);
            }
        }
    }
}

// Render the part
tube_rack();