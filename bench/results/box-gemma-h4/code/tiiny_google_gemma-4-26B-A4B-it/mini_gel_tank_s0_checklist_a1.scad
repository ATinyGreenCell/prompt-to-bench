// Buffer tank for mini horizontal gel-electrophoresis box
// Corrected version: Centered on XY origin, correctly positioned holes.

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
hole_z_pos    = 30.0;  // Z position of holes

$fn = 64;

// --- Calculations ---
inner_l = L - 2 * wall;
inner_w = W - 2 * wall;
inner_h = H - floor;

// Platform placement
// Centered in X, spans full inner Y
platform_x_start = (L / 2) - (platform_len / 2);
platform_z_top   = floor + platform_h_rel;

module tank_body() {
    difference() {
        // Main outer block
        cube([L, W, H], center = true);
        
        // Subtract the interior volume
        // We translate the interior so it sits on the floor
        // Since the outer cube is centered, the floor is at Z = -H/2 + floor
        translate([0, 0, -H/2 + floor + inner_h/2])
            cube([inner_l, inner_w, inner_h + 0.1], center = true);
            
        // Electrode holes (drilled through X-end walls)
        // Holes are at Y = 0 (relative to center) and Z = 30 (absolute)
        // In a centered system, Z_absolute = Z_local + H/2
        // However, the prompt says Z=30. We assume Z=30 is absolute from the bed.
        // Since the part sits at Z=0, we translate the hole to Z = 30 - H/2.
        
        // Hole 1 (Left wall)
        translate([0, hole_y_pos, hole_z_pos - H/2])
            rotate([0, 90, 0])
                cylinder(h = L + 2, d = hole_d, center = true);
                
        // Hole 2 (Right wall)
        // Note: One cylinder through the center covers both if h is large enough
        // but we'll define it clearly.
    }
}

module platform() {
    // The platform is a solid inside the tank.
    // It sits on the floor (Z = floor) and goes up to (floor + platform_h_rel)
    // It is centered in X and spans full inner Y.
    // In centered coordinates:
    // Z_bottom = -H/2 + floor
    // Z_top = -H/2 + floor + platform_h_rel
    
    translate([0, 0, -H/2 + floor + platform_h_rel/2])
        cube([platform_len, inner_w, platform_h_rel], center = true);
}

// --- Final Assembly ---
// The part rests on the XY plane at z = 0.
// The cube is centered, so we translate it down by H/2.

translate([0, 0, 0]) {
    union() {
        // The tank shell
        difference() {
            // Outer shell
            translate([0, 0, -H/2]) cube([L, W, H], center = true);
            
            // Inner cavity
            translate([0, 0, -H/2 + floor]) 
                cube([inner_l, inner_w, H], center = true);
            
            // Electrode holes (Horizontal along X)
            // Positioned at Y=0, Z=30. 
            // Since the cube is translated by -H/2, the hole Z is 30 - H/2.
            translate([0, hole_y_pos, hole_z_pos - H/2])
                rotate([0, 90, 0])
                    cylinder(h = L + 2, d = hole_d, center = true);
        }
        
        // The platform
        // Centered in X, spans full inner Y, sits on floor
        translate([0, 0, -H/2 + floor + platform_h_rel/2])
            cube([platform_len, inner_w, platform_h_rel], center = true);
    }
}