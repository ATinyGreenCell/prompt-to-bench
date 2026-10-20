// Rack for six 50 mL conical (Falcon-type) tubes
// Printed upside down and flipped over after printing

$fn = 64;

// Plate dimensions
plate_x = 130; // mm, X direction
plate_y = 90;  // mm, Y direction
plate_z = 4;   // mm, thickness

// Hole pattern
hole_diameter = 30.5; // mm
hole_spacing_x = 40;  // mm, centre-to-centre in X
hole_spacing_y = 40;  // mm, centre-to-centre in Y
hole_rows = 2;        // number of rows (along Y)
hole_cols = 3;        // number of columns (along X)

// Compute hole positions (centred on plate)
hole_x_offset = (plate_x - (hole_cols - 1) * hole_spacing_x) / 2;
hole_y_offset = (plate_y - (hole_rows - 1) * hole_spacing_y) / 2;

// Walls along long edges (X direction)
// Walls are flush with plate's long edges (inner face at Y = ±plate_y/2)
// Each wall is 4 mm thick, so positioned with inner face at plate edge
wall_thickness = 4;   // mm
wall_height = 70;     // mm

// Plate base
module plate_base() {
    translate([0, 0, plate_z/2]) {
        cube([plate_x, plate_y, plate_z], center=true);
    }
}

// Holes for tubes
module hole_grid() {
    for (i = [0 : hole_cols - 1]) {
        for (j = [0 : hole_rows - 1]) {
            x = -plate_x/2 + hole_x_offset + i * hole_spacing_x;
            y = -plate_y/2 + hole_y_offset + j * hole_spacing_y;
            translate([x, y, -1]) {
                cylinder(h = plate_z + 2, r = hole_diameter/2, center=false);
            }
        }
    }
}

// Walls along long edges (X direction)
module walls() {
    // Front wall (positive Y edge) - inner face at Y = plate_y/2
    // Wall thickness 4 mm, so extends from Y = plate_y/2 to Y = plate_y/2 + wall_thickness
    // Centered at Y = plate_y/2 + wall_thickness/2
    translate([0, plate_y/2 + wall_thickness/2, wall_height/2]) {
        cube([plate_x, wall_thickness, wall_height], center=true);
    }