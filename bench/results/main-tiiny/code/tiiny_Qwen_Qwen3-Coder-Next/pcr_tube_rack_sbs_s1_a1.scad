// Rack for 96 PCR tubes (0.2 mL) with standard microplate footprint
// Dimensions from user specification

// Block dimensions
block_length = 127.76; // X dimension (mm)
block_width  = 85.48;  // Y dimension (mm)
block_height = 20;     // Z dimension (mm)

// Hole grid parameters
hole_diameter = 6.2;   // mm
hole_spacing  = 9.0;   // mm
rows = 8;              // along Y
cols = 12;             // along X

// Position of first hole (A1) from edges
hole_A1_x = 14.38;     // mm from left edge (X)
hole_A1_y = 11.24;     // mm from back edge (Y)

// Chamfer dimensions
chamfer_leg = 5;       // mm

// Set resolution for curves
$fn = 64;

// Calculate hole positions
hole_x_positions = [for (i = [0 : cols-1]) hole_A1_x + i * hole_spacing];
hole_y_positions = [for (j = [0 : rows-1]) hole_A1_y + j * hole_spacing];

// Build the rack
module rack() {
    // Base block - ensure it starts at z=0
    cube([block_length, block_width, block_height]);
    
    // Cut chamfer at A1 corner (left-back corner at origin)
    // The chamfer should be within the block boundaries, not extend beyond
    // Create a triangular prism cutter for the 45-degree chamfer
    translate([0, 0, -0.1]) {
        // The chamfer face is at 45 degrees, with legs of 5mm
        // We cut from the corner (0,0) inward
        rotate([0, 0, 45]) {
            // Position the cutter so the chamfer is exactly 5mm from the corner
            translate([0, -chamfer_leg - 0.01, 0]) {
                cube([chamfer_leg + 0.01, chamfer_leg + 0.01, block_height + 0.2]);
            }
        }
    }
    
    // Cut holes for PCR tubes
    for (i = [0 : cols-1]) {
        for (j = [0 : rows-1]) {
            translate([
                hole_x_positions[i],
                hole_y_positions[j],
                -0.1  // extend below to ensure clean cut
            ]) {
                cylinder(h = block_height + 0.2, r = hole_diameter / 2);
            }
        }
    }
}

// Render the rack
rack();