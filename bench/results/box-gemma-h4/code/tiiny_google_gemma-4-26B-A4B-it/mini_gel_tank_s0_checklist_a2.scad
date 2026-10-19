// Buffer tank for mini horizontal gel-electrophoresis box
// Corrected version: Rests on Z=0, centered on XY, correct hole positioning.

// --- Dimensions ---
L             = 120.0; // Outer Length (X)
W             = 70.0;  // Outer Width (Y)
H             = 40.0;  // Outer Height (Z)
wall          = 3.0;   // Wall thickness
floor         = 3.0;   // Floor thickness
platform_len  = 60.0;  // Platform length (X)
platform_h_rel = 13.0; // Platform height above inner floor
hole_d        = 2.0;   // Electrode hole diameter
hole_y_pos    = 0.0;   // Y position of holes (centered)
hole_z_pos    = 30.0;  // Z position of holes (absolute from Z=0)

$fn = 64;

// --- Calculations ---
inner_l = L - 2 * wall;
inner_w = W - 2 * wall;

// --- Modeling ---

// The part must rest on the XY plane at z = 0.
// We build the tank and then center it on X and Y.

module tank_shell() {
    difference() {
        // Main outer block (starts at Z=0)
        cube([L, W, H]);
        
        // Subtract the interior volume
        // Interior starts at Z = floor
        translate([wall, wall, floor])
            cube([inner_l, inner_w, H]);
            
        // Electrode holes (Horizontal along X)
        // Positioned at Y = W/2 (center), Z = hole_z_pos
        // We use a large cylinder to ensure it pierces the walls.
        translate([-1, W/2 + hole_y_pos, hole_z_pos])
            rotate([0, 90, 0])
                cylinder(h = L + 2, d = hole_d);
    }
}

module platform() {
    // The platform is a solid inside the tank.
    // It sits on the floor (Z = floor) and goes up to (floor + platform_h_rel)
    // It is centered in X and spans full inner Y.
    // In absolute coordinates:
    // Z_bottom = floor
    // Z_top = floor + platform_h_rel
    // X_center = L/2
    // Y_center = W/2
    
    translate([L/2 - platform_len/2, wall, floor])
        cube([platform_len, inner_w, platform_h_rel]);
}

// --- Final Assembly ---
// Center the whole assembly on X and Y, but keep Z at 0.
translate([-L/2, -W/2, 0]) {
    union() {
        tank_shell();
        platform();
    }
}