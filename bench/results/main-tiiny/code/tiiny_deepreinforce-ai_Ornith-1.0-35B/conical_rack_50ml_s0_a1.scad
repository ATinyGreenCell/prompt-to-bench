// Tube rack for 6x 50 mL conical tubes
// Print orientation: plate on bed, walls rise up. Flipped after print.

// Plate dimensions
plate_x = 130;
plate_y = 90;
plate_z = 4;

// Hole parameters
hole_dia = 30.5;
hole_radius = hole_dia / 2;

// Hole grid: 2 rows (Y), 3 columns (X)
rows = 2;
cols = 3;
pitch_x = 40;
pitch_y = 40;

// Wall parameters
wall_length_x = 130;
wall_thickness_y = 4;
wall_height = 70;

// Global fineness for round holes
$fn = 64;

// Calculate grid offsets to centre the holes on the plate
offset_x = (cols - 1) * pitch_x / 2;
offset_y = (rows - 1) * pitch_y / 2;

module rack() {
    // Plate - centred on origin in X and Y
    difference() {
        cube([plate_x, plate_y, plate_z], center = true);
        
        // Six through-holes
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                translate([
                    -offset_x + i * pitch_x,
                    -offset_y + j * pitch_y,
                    -0.01
                ]) {
                    cylinder(d = hole_dia, h = plate_z + 0.02, center = false);
                }
            }
        }
    }
    
    // Two long walls (along X, at Y = ±plate_y/2)
    // Wall is flush with plate edge, so wall center is at plate_y/2 - wall_thickness_y/2
    translate([0, plate_y/2 - wall_thickness_y/2, plate_z]) {
        cube([wall_length_x, wall_thickness_y, wall_height], center = true);
    }
    
    translate([0, -(plate_y/2 - wall_thickness_y/2), plate_z]) {
        cube([wall_length_x, wall_thickness_y, wall_height], center = true);
    }
}

rack();