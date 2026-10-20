$fn = 64; // resolution for cylinders

// Block dimensions (mm)
block_length = 106; // X
block_width  = 72;   // Y
block_height = 30;   // Z

// Tube hole dimensions (mm)
hole_diameter = 11.2;          // diameter of microcentrifuge tube
hole_radius   = hole_diameter / 2;
hole_depth    = 25;             // depth of hole (from top)
hole_bottom_z = block_height - hole_depth; // z coordinate of bottom of hole

// Hole grid parameters
hole_rows    = 4; // along Y
hole_columns = 6; // along X
hole_spacing = 16; // centre‑to‑centre spacing (mm)

// Compute total span of grid
grid_x_span = (hole_columns - 1) * hole_spacing; // 80 mm
grid_y_span = (hole_rows    - 1) * hole_spacing; // 48 mm

// Offsets to centre grid on block
grid_x_offset = (block_length - grid_x_span) / 2; // 13 mm
grid_y_offset = (block_width  - grid_y_span) / 2; // 12 mm

// Build block with holes and centre it on the XY plane
translate([ -block_length/2, -block_width/2, 0]) difference() {
    // Solid block
    cube([block_length, block_width, block_height], center = false);

    // Holes
    for (i = [0 : hole_columns - 1]) {
        for (j = [0 : hole_rows - 1]) {
            translate([
                grid_x_offset + i * hole_spacing,
                grid_y_offset + j * hole_spacing,
                hole_bottom_z
            ]) {
                // Cylinder extends 0.01 mm beyond the top of the block
                cylinder(
                    h = hole_depth + 0.01,
                    r = hole_radius,
                    center = false
                );
            }
        }
    }
}