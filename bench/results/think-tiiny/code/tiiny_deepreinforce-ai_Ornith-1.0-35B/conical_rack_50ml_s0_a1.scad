// Plate dimensions
plate_x = 130;        // X length
plate_y = 90;         // Y length
plate_z = 4;          // Thickness

// Hole dimensions
hole_dia = 30.5;      // Diameter
hole_spacing_x = 40;  // Centre-to-centre spacing in X
hole_spacing_y = 40;  // Centre-to-centre spacing in Y

// Wall dimensions
wall_len = 130;       // Length along X
wall_thick = 4;       // Thickness along Y
wall_height = 70;     // Total height from bed

// Build the solid body (plate + walls)
difference() {
    union() {
        cube([plate_x, plate_y, plate_z]);
        for (y = [-plate_y/2 + wall_thick/2, plate_y/2 - wall_thick/2]) {
            translate([0, y, plate_z])
            cube([wall_len, wall_thick, wall_height - plate_z]);
        }
    }
    for (x = [-hole_spacing_x, 0, hole_spacing_x]) {
        for (y = [-hole_spacing_y/2, hole_spacing_y/2]) {
            translate([x, y, -1])
            cylinder(h=plate_z + 2, d=hole_dia, $fn=64);
        }
    }
}