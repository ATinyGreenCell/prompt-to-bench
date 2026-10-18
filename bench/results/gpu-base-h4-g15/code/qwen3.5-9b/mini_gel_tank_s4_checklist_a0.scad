// Mini horizontal gel-electrophoresis buffer tank.
// Outer dimensions: 120mm (X) x 70mm (Y) x 40mm (Z).
// Wall thickness: 3mm. Floor thickness: 3mm.
// Internal platform: 60mm long (X), full width (Y), 10mm high above inner floor.
// Electrode holes: 2mm diameter, horizontal along X, at ends, y=0, z=30.

$fn = 64;

// Outer dimensions
X_OUT = 120;
Y_OUT = 70;
Z_OUT = 40;

// Thicknesses
wall_thick = 3;
floor_thick = 3;

// Derived inner dimensions
X_IN  = X_OUT - 2 * wall_thick;
Y_IN  = Y_OUT - 2 * wall_thick;
Z_IN  = Z_OUT - floor_thick; // Open top, so Z height is just Z_OUT

// Platform dimensions
plat_len = 60;
plat_w   = Y_IN;
plat_h   = 10; // Height above inner floor

// Electrode hole specs
hole_d   = 2;
hole_y   = 0;
hole_z   = 30;

// Build the tank body (hollow box with floor)
// We build the outer shell and subtract the inner void.
// The inner void is split by the platform.

difference() {
    // 1. The solid outer block
    translate([-X_OUT/2, -Y_OUT/2, 0]) 
        cube([X_OUT, Y_OUT, Z_OUT]);

    // 2. The inner void (everything inside the walls)
    // We define the void as a union of two parts: the bottom chamber and the top chamber.
    // Bottom chamber: From z=0 to z=plat_h.
    // Top chamber: From z=plat_h to z=Z_IN.
    
    // Bottom void part (under the platform)
    translate([-X_IN/2, -Y_IN/2, 0]) 
        cube([X_IN, Y_IN, plat_h]);

    // Top void part (above the platform)
    translate([-X_IN/2, -Y_IN/2, plat_h]) 
        cube([X_IN, Y_IN, Z_IN - plat_h]);

    // 3. The platform itself (solid block inside the void)
    // Positioned at X = 0, Y = -Y_IN/2 to Y_IN/2, Z = plat_h to plat_h + plat_h
    translate([-plat_len/2, -plat_w/2, plat_h]) 
        cube([plat_len, plat_w, plat_h]);

    // 4. Electrode holes
    // Two holes, one at each end (X = +/- X_IN/2), centered in Y (y=0), at z=hole_z.
    // The hole is a cylinder along the X axis.
    for (x_pos = [-1, 1]) {
        translate([x_pos * (X_IN/2 - hole_d/2), hole_y, hole_z]) 
            cylinder(h = X_IN, d = hole_d, $fn = 32);
    }
}