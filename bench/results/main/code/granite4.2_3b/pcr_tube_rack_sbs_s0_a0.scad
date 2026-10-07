// Dimensions (mm) based on user description
block_length    = 127.76;   // X: block length along long axis
block_width     = 85.48;   // Y: block width along short axis
block_height    = 20.0;    // Z: total height of rack (tall enough for PCR tubes)
hole_diameter   = 6.2;     // vertical through-hole diameter
hole_spacing_x  = 9.0;     // centre-to-centre spacing along X (columns)
hole_spacing_y  = 9.0;     // centre-to-centre spacing along Y (rows)
first_hole_offset_x = 14.38;   // distance from left edge to first hole centre
first_hole_offset_y = 11.24;   // distance from back edge to first hole centre
num_columns     = 12;      // columns along X (A1, B1, ..., L1)
num_rows        = 8;       // rows along Y (A1, A2, ..., H8)
chamfer_leg_len  = 5.0;     // chamfer leg length in mm

// Compute grid positions: columns along X, rows along Y
for (cols = [for (i = [0 : num_columns - 1]) { first_hole_offset_x + i * hole_spacing_x }],
      rows = [for (j = [0 : num_rows - 1]) { first_hole_offset_y + j * hole_spacing_y }] ) {
    // Place a vertical through-hole at each grid point
    // Hole centre is at (cols[i], rows[j], block_height/2) because rack rests on XY plane, top of holes at mid-height.
    // We model the hole as a cylinder with its axis along Z; the hole passes through the block from bottom to top.
    // The cylinder's centre is at (cols[i], rows[j], block_height/2) so it spans vertically across the block.
    
    // Create a cylindrical hole of diameter = hole_diameter, radius = hole_diameter/2, centered along Z axis.
    // Use difference to cut out the hole from the solid block (which is initially filled).
    // We'll build the entire rack as a solid block first, then subtract all holes and chamfer.
    
    // For clarity, we define the hole geometry directly via difference operations later.
}