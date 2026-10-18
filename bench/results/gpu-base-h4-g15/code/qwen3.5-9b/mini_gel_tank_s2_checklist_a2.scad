// Mini Horizontal Gel Electrophoresis Buffer Tank
// Outer dimensions: 120 x 70 x 40 mm
// Wall thickness: 3 mm
// Floor thickness: 3 mm
// Inner platform: 60 mm long, full width, 10 mm high from inner floor

$fn = 64;

// Outer dimensions
X_OUT = 120;
Y_OUT = 70;
Z_OUT = 40;

// Thicknesses
wall_t = 3;
floor_t = 3;

// Inner dimensions
X_IN  = X_OUT - 2 * wall_t;
Y_IN  = Y_OUT - 2 * wall_t;
Z_IN  = Z_OUT - floor_t;

// Platform dimensions
plat_len = 60;
plat_w   = Y_IN;
plat_h   = 10; // Height from inner floor

// Electrode hole
hole_d   = 2;
hole_y   = 0;
hole_z   = 30;

difference() {
    // 1. Outer Shell (Solid Block)
    translate([-X_OUT / 2, -Y_OUT / 2, 0]) 
        cube([X_OUT, Y_OUT, Z_OUT]);
    
    // 2. Inner Void (Subtract this to create the tank cavity)
    // The void consists of the two side chambers and the space above the platform.
    // All void extends from the inner floor (z=3) to the top (z=40).
    
    void_h = X_IN - plat_len; // Total width of chambers (24)
    half_void = void_h / 2;   // Width of one chamber (12)
    
    // Chamber 1 (Left)
    // X range: -X_IN/2 to -X_IN/2 + half_void
    // Y range: -Y_IN/2 to Y_IN/2
    // Z range: floor_t to Z_OUT
    translate([-X_IN / 2, -Y_IN / 2, floor_t]) 
        cube([half_void, Y_IN, Z_OUT - floor_t]);
        
    // Chamber 2 (Right)
    // X range: X_IN/2 - half_void to X_IN/2
    // Y range: -Y_IN/2 to Y_IN/2
    // Z range: floor_t to Z_OUT
    translate([X_IN / 2 - half_void, -Y_IN / 2, floor_t]) 
        cube([half_void, Y_IN, Z_OUT - floor_t]);
        
    // Space Above Platform
    // X range: -X_IN/2 to X_IN/2
    // Y range: -Y_IN/2 to Y_IN/2
    // Z range: plat_h + floor_t to Z_OUT
    translate([-X_IN / 2, -Y_IN / 2, plat_h + floor_t]) 
        cube([X_IN, Y_IN, Z_OUT - (plat_h + floor_t)]);
        
    // 3. Platform (Solid block inside the void)
    // Positioned at the bottom of the void.
    // Bottom at z = floor_t. Top at z = floor_t + plat_h.
    // Centered in X. Spans full inner width Y_IN.
    translate([
        -X_OUT / 2 + (X_OUT - plat_len) / 2, 
        -Y_OUT / 2, 
        0