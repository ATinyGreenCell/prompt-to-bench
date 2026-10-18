// Mini Horizontal Gel Electrophoresis Buffer Tank
// Outer dimensions: 120 (X) x 70 (Y) x 40 (Z)
// Wall thickness: 3 mm
// Floor thickness: 3 mm
// Internal platform: 60 (X) x 70 (Y) x 10 (height from inner floor)
// Centred on origin (X, Y).

$fn = 64;

// Outer dimensions
X_out = 120;
Y_out = 70;
Z_out = 40;

// Thicknesses
wall_t = 3;
floor_t = 3;

// Derived inner dimensions
// Outer box is now centred: -60 to +60 in X.
X_in  = X_out - 2 * wall_t; // 114
Y_in  = Y_out - 2 * wall_t; // 64
Z_in  = Z_out - floor_t;    // 37 (Inner floor is at z=0, top at z=3)

// Platform dimensions
plat_len = 60;
plat_w   = Y_in; // Full inner width
plat_h   = 10;   // Height above inner floor (Top at z = 3 + 10 = 13)

// Electrode hole dimensions
hole_d   = 2;
hole_y   = 0;
hole_z   = 30;   // Height from inner floor (z = 30)

// Main assembly
difference() {
    union() {
        // 1. Tank Shell
        // Outer box centred at origin
        translate([-X_out / 2, -Y_out / 2, 0])
            cube([X_out, Y_out, Z_out]);
        
        // Inner void (air space)
        // Starts at z = floor_t (3)
        // X range: -X_in/2 to +X_in/2
        // Y range: -Y_in/2 to +Y_in/2
        translate([-X_in / 2, -Y_in / 2, floor_t])
            cube([X_in, Y_in, Z_in]);
        
        // 2. Raised Platform
        // Sits on inner floor (z = floor_t)
        // Spans full inner width (Y_in)
        // Centred in X
        // Height plat_h
        translate([-plat_len / 2, -Y_in / 2, floor_t])
            cube([plat_len, plat_w, plat_h]);
        
        // 3. Electrode Holes
        // Two holes, one at each end of the inner tank (X = +/- X_in/2)
        // Horizontal along X axis
        // Position: y = hole_y, z = hole_z (relative to inner floor)
        for (x_pos = [-X_in / 2, X_in / 2]) {
            translate([x_pos, hole_y, hole_z])
                cylinder(h = X_in, d = hole_d, $fn = 32);
        }
    }
}