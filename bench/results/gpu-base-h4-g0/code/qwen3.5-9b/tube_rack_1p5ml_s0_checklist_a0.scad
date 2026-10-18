// Bench rack for 1.5 mL microcentrifuge tubes.
// Solid block 106x72x30 mm with 24 vertical holes (4 rows x 6 columns).
// Holes are 11.2 mm diameter, 25 mm deep, centred on the block.

L     = 106;   // Length (X)
W     = 72;    // Width (Y)
H     = 30;    // Height (Z)
n_x   = 6;     // Number of holes along X
n_y   = 4;     // Number of holes along Y
p_x   = 16;    // Pitch along X
p_y   = 16;    // Pitch along Y
d_h   = 11.2;  // Hole diameter
d_h_d = 11.2;  // Hole depth (depth of the cut)

$fn = 64;

// Calculate positions for the hole grid centred on the block
// X positions: 0 to n_x-1
// Y positions: 0 to n_y-1
// Offset to centre: (n-1)/2 * pitch
offset_x = (n_x - 1) * p_x / 2;
offset_y = (n_y - 1) * p_y / 2;

difference() {
    // Main block
    translate([-L / 2, -W / 2, 0]) cube([L, W, H]);

    // Holes
    for (i = [0 : n_x - 1]) {
        for (j = [0 : n_y - 1]) {
            // Calculate position for this hole
            pos_x = -L / 2 + (i - offset_x / p_x) * p_x;
            pos_y = -W / 2 + (j - offset_y / p_y) * p_y;
            
            // Hole cylinder: 11.2mm diameter, 25mm deep
            // Extend slightly past the bottom face to ensure clean cut
            translate([pos_x, pos_y, 0]) 
                cylinder(h = d_h_d + 0.1, d = d_h);
        }
    }
}