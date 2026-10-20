// Dimensions (mm)
block_len = 106;
block_wid = 72;
block_hgt = 30;
hole_diam = 11.2;
hole_depth = 25;
floor_thick = 5;
pitch = 16;
rows = 4;
cols = 6;
$fn = 64;

// Block
difference() {
    cube([block_len, block_wid, block_hgt]);
    
    // Holes
    for (row = [0:rows-1]) {
        for (col = [0:cols-1]) {
            // Calculate center of the block
            block_center_x = block_len / 2;
            block_center_y = block_wid / 2;
            
            // Calculate position relative to block center
            x_offset = (col - (cols - 1) / 2) * pitch;
            y_offset = (row - (rows - 1) / 2) * pitch;
            
            // Absolute position
            x_pos = block_center_x + x_offset;
            y_pos = block_center_y + y_offset;
            
            // Cut the hole
            // Translate slightly up to extend past the top face (0.01mm)
            translate([x_pos, y_pos, floor_thick + 0.01])
            cylinder(h=hole_depth, d=hole_diam, center=false);
        }
    }
}