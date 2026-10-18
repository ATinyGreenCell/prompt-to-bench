// Mini horizontal gel-electrophoresis buffer tank.
// Outer dimensions: 120 (X) x 70 (Y) x 40 (Z).
// Wall thickness: 3 mm. Floor thickness: 3 mm.
// Inner floor height: 3 mm.
// Raised platform: 60 mm long (X), full inner width (Y), top at Z=13.
// Electrode holes: 2 mm diameter, horizontal along X, at Y=0, Z=30.

$fn = 64;

// Outer dimensions
X_out = 120;
Y_out = 70;
Z_out = 40;

// Thicknesses
wall_t = 3;
floor_t = 3;

// Inner dimensions
X_in  = X_out - 2 * wall_t;
Y_in  = Y_out - 2 * wall_t;
Z_in  = Z_out - floor_t;

// Platform dimensions
plat_len = 60;
plat_w   = Y_in;
plat_top_z = 13;

// Electrode hole specs
hole_d = 2;
hole_y = 0;
hole_z = 30;

// Main tank body (hollow box)
// We build the outer shell and subtract the inner void.
// The void starts at the inner floor level (Z = floor_t).

difference() {
    // 1. Outer Shell
    // Bottom slab
    translate([0, 0, 0]) cube([X_out, Y_out, floor_t]);
    // Side walls (left and right)
    translate([0, 0, floor_t]) cube([X_out, wall_t, Z_out - floor_t]);
    translate([0, Y_out - wall_t, floor_t]) cube([X_out, wall_t, Z_out - floor_t]);
    // Front and back walls
    translate([wall_t, 0, floor_t]) cube([wall_t, Y_out, Z_out - floor_t]);
    translate([X_out - wall_t, 0, floor_t]) cube([wall_t, Y_out, Z_out - floor_t]);

    // 2. Inner Void (Subtract this to make it hollow)
    // The void is the space inside the walls, starting from the floor.
    translate([wall_t, wall_t, floor_t]) cube([X_in, Y_in, Z_in]);

    // 3. Raised Platform
    // Position: Centred in X, full width in Y, height from floor to plat_top_z.
    // Base Z = floor_t. Top Z = plat_top_z.
    translate([
        (X_out - plat_len) / 2, 
        wall_t, 
        floor_t
    ]) cube([plat_len, plat_w, plat_top_z - floor_t]);

    // 4. Electrode Holes
    // Horizontal holes along X axis.
    // Position: Y = hole_y, Z = hole_z.
    // Since the hole is horizontal along X, the cylinder axis is X.
    // We need to rotate the cylinder 90 deg around Y to point along X.
    for (side = [-1, 1]) {
        translate([
            0, 
            side * hole_y, 
            hole_z
        ]) rotate([0, 90, 0]) cylinder(h = X_out, d = hole_d);
    }
}