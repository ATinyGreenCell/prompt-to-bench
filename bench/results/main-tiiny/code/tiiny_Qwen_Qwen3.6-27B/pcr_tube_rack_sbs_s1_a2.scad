// Dimensions for 96-well PCR tube rack (0.2 mL tubes)
// Standard ANSI/SLAS microplate footprint

// Block dimensions (mm)
block_length = 127.76;   // X dimension
block_width = 85.48;     // Y dimension
block_height = 20.0;     // Z dimension

// Hole grid parameters (mm)
hole_diameter = 6.2;
hole_spacing_x = 9.0;    // Column spacing (X)
hole_spacing_y = 9.0;    // Row spacing (Y)
cols = 12;               // Number of columns (X)
rows = 8;                // Number of rows (Y)

// Position of first hole (A1) relative to block edges (mm)
a1_offset_x = 14.38;     // Distance from left edge (X)
a1_offset_y = 11.24;     // Distance from back edge (Y)

// Chamfer parameters (mm)
chamfer_leg = 5.0;       // 45-degree chamfer leg length

// Rendering quality
$fn = 64;

// Main module
module pcr_rack() {
    difference() {
        // Solid block, resting on z=0
        translate([-block_length/2, -block_width/2, 0])
            cube([block_length, block_width, block_height]);
        
        // 96 through-holes
        for (col = [0 : cols-1]) {
            for (row = [0 : rows-1]) {
                // Calculate hole center position
                hole_x = a1_offset_x + col * hole_spacing_x;
                hole_y = a1_offset_y + row * hole_spacing_y;
                
                // Translate to global coordinates (centered on origin)
                // Holes extend slightly past top and bottom to ensure clean cut
                translate([hole_x - block_length/2, hole_y - block_width/2, -0.01])
                    cylinder(h = block_height + 0.02, d = hole_diameter, center = false);
            }
        }
        
        // 45-degree chamfer at A1 corner (left-back-top corner)
        // A1 is at (a1_offset_x, a1_offset_y) in local coords
        // In global coords: (a1_offset_x - block_length/2, a1_offset_y - block_width/2)
        // The chamfer is at the top corner, so it starts at z = block_height
        // We use a cube rotated 45 degrees to create the chamfer
        chamfer_x = a1_offset_x - block_length/2;
        chamfer_y = a1_offset_y - block_width/2;
        
        // The chamfer cube is placed at the corner and rotated
        // To ensure it cuts properly, we extend it slightly
        translate([chamfer_x, chamfer_y, block_height])
            rotate([0, 0, 45])
                cube([chamfer_leg, chamfer_leg, chamfer_leg]);
    }
}

// Render the rack
pcr_rack();