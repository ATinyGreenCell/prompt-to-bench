// Bench rack for 1.5 mL microcentrifuge tubes
// Block dimensions
block_x = 106;
block_y = 72;
block_z = 30;

// Hole dimensions
hole_dia = 11.2;
hole_depth = 25;
floor_thickness = 5;

// Hole grid spacing
pitch_x = 16;
pitch_y = 16;
rows = 4;
cols = 6;

// Derived dimensions
hole_radius = hole_dia / 2;
grid_x_total = (cols - 1) * pitch_x;
grid_y_total = (rows - 1) * pitch_y;

// Hole positions (centered on origin)
x_positions = [for (i = 0; i < cols; i++) -grid_x_total/2 + i * pitch_x];
y_positions = [for (j = 0; j < rows; j++) -grid_y_total/2 + j * pitch_y];

// Block (rests on XY plane, centered in X and Y)
block = translate([0, 0, 0]) cube([block_x, block_y, block_z]);

// Final part
difference() {
    block;
    for (x in x_positions) {
        for (y in y_positions) {
            translate([x, y, block_z - hole_depth + 0.01]) {
                cylinder(h = hole_depth + 0.02, r = hole_radius, center = false, $fn = 64);
            }
        }
    }
}