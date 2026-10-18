// Mini Horizontal Gel Electrophoresis Buffer Tank
// Outer dimensions: 120 (X) x 70 (Y) x 40 (Z)
// Wall thickness: 3 mm
// Floor thickness: 3 mm
// Internal platform: 60 (X) x 70 (Y) x 10 (height from inner floor)

$fn = 64;

// Outer dimensions
X_out = 120;
Y_out = 70;
Z_out = 40;

// Thicknesses
wall_t = 3;
floor_t = 3;

// Derived inner dimensions
X_in  = X_out - 2 * wall_t;
Y_in  = Y_out - 2 * wall_t;
Z_in  = Z_out - floor_t; // Inner floor is at z = 0, top of floor is at z = floor_t

// Platform dimensions
plat_len = 60;
plat_w   = Y_in;
plat_h   = 10; // Height above inner floor

// Electrode hole dimensions
hole_d   = 2;
hole_y   = 0;
hole_z   = 30; // Height from inner floor

// Helper to create the main tank shell
module tank_shell() {
    // Base block (floor + walls)
    // Floor is at z=0, thickness floor_t. Walls go up to Z_out.
    // We construct the outer box and subtract the inner void.
    
    // Outer block
    translate([0, 0, 0]) 
        cube([X_out, Y_out, Z_out]);
    
    // Inner void (air space)
    // The void starts at z = floor_t and goes up to Z_out.
    // X range: wall_t to X_out - wall_t
    // Y range: wall_t to Y_out - wall_t
    translate([wall_t, wall_t, floor_t])
        cube([X_in, Y_in, Z_in]);
}

// Helper to create the raised platform
module platform() {
    // Platform sits on the inner floor (z = floor_t)
    // It spans the full inner width (Y_in)
    // It is centered in X
    // Height is plat_h
    
    translate([-plat_len / 2, 0, floor_t])
        cube([plat_len, plat_w, plat_h]);
}

// Helper to create the electrode holes
module electrode_holes() {
    // Two holes, one at each end (X = +/- X_in/2)
    // Hole is horizontal along X axis
    // Position: y = hole_y, z = hole_z (relative to inner floor)
    
    for (x_pos = [-X_in / 2, X_in / 2]) {
        translate([x_pos, hole_y, hole_z])
            cylinder(h = X_in, d = hole_d, $fn = 32);
    }
}

// Main assembly
difference() {
    union() {
        tank_shell();
        platform();
    }
    electrode_holes();
}