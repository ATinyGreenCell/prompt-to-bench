// Buffer tank for mini horizontal gel-electrophoresis box
// Designed for FDM 3D printing

// --- Dimensions ---
outer_x = 120;      // Total length (X)
outer_y = 70;       // Total width (Y)
outer_z = 40;       // Total height (Z)
wall_t  = 3;        // Wall thickness
floor_t = 3;        // Floor thickness

platform_len = 60;  // Length of the central platform (X)
platform_h   = 13;  // Height of platform top from the inner floor (Z_inner + platform_h)
// Note: User specified platform top is 10mm above inner floor. 
// Inner floor is at z = 3. So platform top is at z = 3 + 10 = 13.

hole_d = 2;         // Diameter of electrode wire holes
hole_y = 0;         // Y-coordinate for holes (centered on Y axis)
hole_z = 30;        // Z-coordinate for holes

$fn = 64;

// --- Calculations ---
inner_x_start = wall_t;
inner_x_end   = outer_x - wall_t;
inner_y_start = wall_t;
inner_y_end   = outer_y - wall_t;
inner_z_start = floor_t;
inner_z_end   = outer_z;

// Platform placement
platform_x_start = (outer_x / 2) - (platform_len / 2);
platform_x_end   = (outer_x / 2) + (platform_len / 2);
platform_z_top   = floor_t + 10; // 10mm above inner floor

module tank_body() {
    difference() {
        // Main outer block
        cube([outer_x, outer_y, outer_z]);
        
        // Hollow out the interior
        translate([wall_t, wall_t, floor_t])
            cube([outer_x - 2*wall_t, outer_y - 2*wall_t, outer_z]);
    }
}

module platform() {
    // The platform spans the full inner width (Y)
    // It is 60mm long in X, centered.
    // It sits on the floor, but the user says "top is 10mm above inner floor"
    // So the height of the platform block is 10mm.
    translate([platform_x_start, wall_t, floor_t])
        cube([platform_len, outer_y - 2*wall_t, 10]);
}

module electrode_holes() {
    // Holes through the X-end walls at y=0 (relative to center) and z=30
    // Since the tank is centered on X and Y, y=0 is the center of the Y dimension.
    // The walls are at x=0 and x=outer_x.
    
    // Hole 1 (Left wall)
    translate([-1, outer_y/2, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_t + 2, d = hole_d);
            
    // Hole 2 (Right wall)
    translate([outer_x, outer_y/2, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_t + 2, d = hole_d);
}

// --- Final Assembly ---
// The tank rests on the XY plane at z=0
union() {
    difference() {
        tank_body();
        electrode_holes();
    }
    // We add the platform as a union because it is a "solid raised platform"
    // However, the tank_body is already a solid. 
    // To make the platform part of the solid, we use union.
    // But the platform is inside the hollow part. 
    // So we must subtract the hollow part from the union of (body + platform).
    // A cleaner way:
    // 1. Create the solid tank shell.
    // 2. Add the platform.
    // 3. Subtract the electrode holes.
}

// Corrected construction logic to ensure the platform is part of the solid:
// We will use a single difference() to avoid overlapping solids.

difference() {
    // The main solid block
    union() {
        // The outer shell
        cube([outer_x, outer_y, outer_z]);
        // The platform (added to the solid)
        translate([platform_x_start, wall_t, floor_t])
            cube([platform_len, outer_y - 2*wall_t, 10]);
    }
    
    // Subtract the hollow interior
    translate([wall_t, wall_t, floor_t])
        cube([outer_x - 2*wall_t, outer_y - 2*wall_t, outer_z]);
        
    // Subtract the electrode holes
    electrode_holes();
}