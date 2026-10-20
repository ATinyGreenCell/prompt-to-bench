// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed (z=0), walls rise up.
// After printing, flip over so walls are on bottom and tubes pass through holes.

// --- Plate dimensions ---
plate_x = 130;       // Plate length (X)
plate_y = 90;         // Plate width (Y)
plate_z = 4;          // Plate thickness

// --- Hole pattern ---
hole_dia = 30.5;     // Hole diameter
hole_rows = 2;        // Number of rows (along Y)
hole_cols = 3;        // Number of columns (along X)
pitch_x = 40;         // Centre-to-centre spacing in X
pitch_y = 40;          // Centre-to-centre spacing in Y

// --- Wall dimensions ---
wall_length = 130;    // Wall length (X), flush with plate long edge
wall_thick = 4;       // Wall thickness (Y)
wall_height = 70;     // Wall height from plate top

// --- Derived values ---
// Hole centres: centred on plate in X and Y
hole_x_start = -(hole_cols - 1) * pitch_x / 2;
hole_y_start = -(hole_rows - 1) * pitch_y / 2;

// Wall position: flush with plate long edge (Y = ±plate_y/2)
wall_y_pos = plate_y / 2;

// --- Build the part ---
difference() {
    // Plate
    union() {
        // Main plate body
        cube([plate_x, plate_y, plate_z], center = [false, false, false]);
        
        // Two walls along long edges (Y = ±plate_y/2)
        // Wall along Y = +plate_y/2
        translate([0, wall_y_pos, 0])
            cube([wall_length, wall_thick, wall_height], center = [false, false, false]);
        
        // Wall along Y = -plate_y/2
        translate([0, -wall_y_pos, 0])
            cube([wall_length, wall_thick, wall_height], center = [false, false, false]);
    }
    
    // Cut through-holes
    for (i = [0 : hole_cols - 1]) {
        for (j = [0 : hole_rows - 1]) {
            hx = hole_x_start + i * pitch_x;
            hy = hole_y_start + j * pitch_y;
            
            translate([hx, hy, -0.01])
                cylinder(d = hole_dia, h = plate_z + 0.02, $fn = 64);
        }
    }
}