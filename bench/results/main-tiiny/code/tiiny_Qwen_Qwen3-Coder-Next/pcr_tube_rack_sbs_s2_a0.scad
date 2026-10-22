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
chamfer_angle = 45;

// Compute hole positions
hole_x = [for (i = [0 : cols-1]) edge_offset_x + i * well_spacing];
hole_y = [for (j = [0 : rows-1]) edge_offset_y + j * well_spacing];

// Center of block
block_center_x = block_length / 2;
block_center_y = block_width / 2;

// Chamfer location: at A1 corner (left-back edge)
chamfer_x = edge_offset_x;
chamfer_y = edge_offset_y;

// Chamfer block dimensions (to ensure full cut)
chamfer_depth = 20; // extend through height
chamfer_width = 20; // extend beyond chamfer region

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
        
        // 45-degree chamfer at A1 corner (left-back edge)
        // Chamfer is cut from the corner where x=edge_offset_x, y=edge_offset_y
        // We create a triangular prism and subtract it
        translate([
            edge_offset_x - 0.01,
            edge_offset_y - 0.01,
            -0.01
        ]) {
            rotate([0, 0, 45]) {
                translate([0, 0, 0]) {
                    cube([chamfer_leg + 0.02, chamfer_leg + 0.02, block_height + 0.02]);
                }
            }
            // Additional chamfer to ensure clean cut at 45 degrees
            // The above rotation creates a square in XY, but we need a triangular prism
            // So we intersect with a half-space to get the triangle
            rotate([0, 0, 45]) {
                translate([0, 0, -0.01]) {
                    cube([chamfer_leg + 0.02, chamfer_leg + 0.02, block_height + 0.02]);
                }
            }
        }
        
        // To get a proper 45-degree chamfer triangle, we use a different approach:
        // A triangular prism with legs of 5mm along X and Y
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