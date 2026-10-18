// Mini horizontal gel-electrophoresis buffer tank.
// Outer dimensions: 120 (X) x 70 (Y) x 40 (Z).
// Wall thickness: 3 mm. Floor thickness: 3 mm.
// Inner floor Z = 3 mm.
// Central platform: 60 mm long (X), full inner width (Y), top at Z = 13 mm.
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
X_in  = X_out - 2 * wall_t; // 114
Y_in  = Y_out - 2 * wall_t; // 64
Z_in  = Z_out - floor_t;    // 37

// Platform dimensions
plat_len = 60;
plat_w   = Y_in;
plat_top = 13; // Absolute Z height of top surface

// Electrode hole parameters
hole_d = 2;
hole_y = 0;
hole_z = 30;

// Main tank body (hollow box)
// We build the outer shell and subtract the inner void.
// The inner void is defined by the inner floor and inner walls.
// To ensure clean cuts, we extend the cutting void slightly.

difference() {
    // 1. The solid outer block
    translate([-X_out/2, -Y_out/2, 0]) 
        cube([X_out, Y_out, Z_out]);

    // 2. The inner void (subtracted)
    // Inner void dimensions:
    // X: from wall_t to X_out - wall_t
    // Y: from wall_t to Y_out - wall_t
    // Z: from floor_t to Z_out (open top)
    
    // We subtract a block that represents the empty space.
    // To cut the walls cleanly, we extend the void slightly past the outer faces.
    translate([-X_out/2, -Y_out/2, 0]) 
        cube([X_out + 0.1, Y_out + 0.1, Z_out + 0.1]);
    
    // Wait, the logic above (subtracting a larger block) creates a hole through the whole thing.
    // Correct approach: Union of the solid parts, then subtract the void.
    // Or: Start with solid, subtract the void shape.
    
    // Let's restart the geometry logic for clarity.
    // Part A: Solid block.
    // Part B: Void shape (to be subtracted).
    
    // Void shape:
    // It is a rectangular prism with an open top.
    // X range: [wall_t, X_out - wall_t]
    // Y range: [wall_t, Y_out - wall_t]
    // Z range: [floor_t, Z_out]
    
    // We need to subtract this void.
    // To cut the walls cleanly, the void shape should extend slightly beyond the inner faces.
    
    // Define the void box
    void_x = X_in + 0.1;
    void_y = Y_in + 0.1;
    void_z = Z_out - floor_t + 0.1; // Extend slightly above the top of the void
    
    translate([-X_out/2 + wall_t + 0.05, -Y_out/2 + wall_t + 0.05, floor_t - 0.05])
        cube([void_x, void_y, void_z]);
    
    // 3. The central platform
    // It sits on the inner floor.
    // Bottom Z = floor_t = 3.
    // Top Z = 13.
    // Length = 60, centered in X.
    // Width = Y_in.
    
    translate([-plat_len/2, -plat_w/2, floor_t])
        cube([plat_len, plat_w, plat_top - floor_t]);
    
    // 4. Electrode holes
    // Two holes, one at each end (X = +/- X_in/2).
    // Hole is a cylinder along X axis.
    // Position: Y = 0, Z = 30.
    // Radius = hole_d / 2.
    
    for (side = [-1, 1]) {
        translate([side * (X_in / 2), hole_y, hole_z])
            cylinder(h = X_in + 0.1, d = hole_d);
    }
}