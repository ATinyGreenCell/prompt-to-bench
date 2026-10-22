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
        
        // 45-degree chamfer at A1 corner (left-back edge of the well grid)
        // The chamfer is cut into the block at the corner near (edge_offset_x, edge_offset_y)
        // We create a triangular prism that cuts diagonally across the corner
        translate([
            edge_offset_x - 0.01,
            edge_offset_y - 0.01,
            -0.01
        ]) {
            // Cut with a triangular prism at 45 degrees
            rotate([0, 0, 45]) {
                translate([0, 0, 0]) {
                    cube([chamfer_leg + 0.02, chamfer_leg + 0.02, block_height + 0.02]);
                }
            }
            // But we need only the triangle, not the square
            // So we intersect with the half-space x + y <= chamfer_leg
            rotate([0, 0, 45]) {
                translate([0, 0, -0.01]) {
                    cube([chamfer_leg + 0.02, chamfer_leg + 0.02, block_height + 0.02]);
                }
            }
        }
        
        // Better approach: use a proper triangular prism
        translate([
            edge_offset_x - 0.01,
            edge_offset_y - 0.01,
            -0.01
        ]) {
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