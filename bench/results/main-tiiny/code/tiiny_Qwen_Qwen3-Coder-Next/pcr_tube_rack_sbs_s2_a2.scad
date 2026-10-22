// 96-well PCR tube rack with ANSI/SLAS footprint
// Dimensions in mm

// Block dimensions
block_length = 127.76; // X
block_width  = 85.48;  // Y
block_height = 20;     // Z

// Well parameters
well_diameter = 6.2;
well_spacing  = 9.0;
rows = 8;
cols = 12;

// Edge offsets for first well (A1)
edge_offset_x = 14.38; // from left edge (X)
edge_offset_y = 11.24; // from back edge (Y)

// Chamfer parameters
chamfer_leg = 5;

// Compute hole positions
hole_x = [for (i = [0 : cols-1]) edge_offset_x + i * well_spacing];
hole_y = [for (j = [0 : rows-1]) edge_offset_y + j * well_spacing];

// Build rack
module rack() {
    difference() {
        // Main block
        cube([block_length, block_width, block_height]);
        
        // Wells (96 holes)
        for (i = [0 : cols-1]) {
            for (j = [0 : rows-1]) {
                translate([
                    hole_x[i],
                    hole_y[j],
                    -0.01
                ]) {
                    cylinder(h = block_height + 0.02, r = well_diameter / 2, $fn = 64);
                }
            }
        }
        
        // 45-degree chamfer at A1 corner (left-back edge of the block)
        // The chamfer is cut from the corner of the block at (0,0)
        // but the A1 well is positioned at (edge_offset_x, edge_offset_y)
        // So the chamfer should be at the block corner (0,0)
        translate([0, 0, -0.01]) {
            linear_extrude(height = block_height + 0.02) {
                polygon(points = [
                    [0, 0],
                    [chamfer_leg, 0],
                    [0, chamfer_leg]
                ]);
            }
        }
    }
}

// Render
rack();