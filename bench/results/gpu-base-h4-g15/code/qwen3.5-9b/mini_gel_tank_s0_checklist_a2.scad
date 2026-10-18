// Mini Horizontal Gel Electrophoresis Buffer Tank
// Outer dimensions: 120 (X) x 70 (Y) x 40 (Z)
// Wall thickness: 3 mm
// Floor thickness: 3 mm
// Inner platform: 60 (X) x 70 (Y) x 10 (height above inner floor)
// Electrode holes: 2 mm diameter, horizontal along X, at Y=0, Z=30

$fn = 64;

// Outer Dimensions
X_out = 120;
Y_out = 70;
Z_out = 40;

// Wall Thickness
wall = 3;

// Floor Thickness
floor_t = 3;

// Inner Dimensions
X_in  = X_out - 2 * wall;
Y_in  = Y_out - 2 * wall;
Z_in  = Z_out - floor_t; 

// Platform Dimensions
plat_len = 60; 
plat_w   = Y_in; 
plat_h   = 10;  // Height above inner floor

// Electrode Hole Specs
hole_d   = 2;
hole_z   = 30;  // Z coordinate of the hole center

// Main assembly
difference() {
    union() {
        // 1. Tank Shell
        translate([0, 0, 0]) cube([X_out, Y_out, Z_out]);
        
        // 2. Cut inner volume (air space)
        // Starts at Z = floor_t
        translate([wall, wall, floor_t]) cube([X_in, Y_in, Z_in]);
        
        // 3. Platform
        // Sits on the inner floor (Z = floor_t)
        // Top of platform = floor_t + plat_h = 3 + 10 = 13 mm
        translate([
            (X_out - plat_len) / 2, 
            0, 
            floor_t
        ]) 
        cube([plat_len, plat_w, plat_h]);
    }
    
    // 4. Electrode Holes
    // Two holes, one at each end wall (X=wall and X=X_out-wall)
    // Both centered at Y=0, Z=30
    // Holes run along X axis
    
    // Left Wall Hole
    translate([wall, 0, hole_z]) {
        rotate([90, 0, 0]) cylinder(h = wall + 1, d = hole_d);
    }
    
    // Right Wall Hole
    translate([X_out - wall, 0, hole_z]) {
        rotate([90, 0, 0]) cylinder(h = wall + 1, d = hole_d);
    }
}