// --- Buffer tank for mini horizontal gel-electrophoresis box ---
// Print orientation: resting on XY plane at z = 0, building upward (+Z)
// Centre on origin in X and Y

// Outer dimensions
outer_x = 120;       // mm, outer length in X
outer_y = 70;         // mm, outer width in Y
outer_z = 40;         // mm, outer height in Z

// Wall and floor thickness
wall_thick = 3;       // mm, wall thickness
floor_thick = 3;      // mm, floor thickness

// Gel platform
platform_length = 60; // mm, length in X (centred)
platform_top_z = 13;  // mm, top of platform above inner floor (z = 13)
platform_thickness = platform_top_z - floor_thick; // 10 mm thick platform

// Electrode wire holes
wire_hole_dia = 2;    // mm, diameter of wire holes
wire_hole_z = 30;     // mm, height of wire holes

// Inner dimensions
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;

// Platform half-lengths
plat_half_x = platform_length / 2;

// Build the tank
module tank() {
    // Outer shell (solid block)
    difference() {
        // Main outer block
        cube([outer_x, outer_y, outer_z], center = false);
        
        // Inner cavity (subtract inner volume)
        translate([wall_thick, wall_thick, floor_thick]) {
            cube([inner_x, inner_y, outer_z - floor_thick], center = false);
        }
        
        // Gel platform (solid, so we subtract the space it occupies from the cavity)
        // The platform is solid, so we need to add it back
        // Actually, let's think differently: build the tank as a shell, then add the platform
        
        // Let me reconsider: build the outer shell, then subtract the inner cavity,
        // but leave the platform area filled. The platform is at z = floor_thick to z = platform_top_z.
        // The inner cavity goes from z = floor_thick to z = outer_z.
        // The platform occupies: x from (outer_x/2 - plat_half_x) to (outer_x/2 + plat_half_x),
        // y from 0 to inner_y (full inner width), z from floor_thick to platform_top_z.
        
        // So we need to add back the platform volume to the inner cavity subtraction
        // Let's use a different approach: build the tank walls and floor, then add the platform
        
        // Actually, let me rebuild this more carefully:
        // 1. Start with a solid block
        // 2. Subtract the inner cavity (which is the tank interior)
        // 3. Add back the platform (which is solid)
    }
    
    // Let me use a cleaner approach:
    union() {
        // Tank walls and floor (hollow box)
        difference() {
            // Outer block
            cube([outer_x, outer_y, outer_z], center = false);
            
            // Inner cavity (open at top)
            translate([wall_thick, wall_thick, floor_thick]) {
                cube([inner_x, inner_y, outer_z - floor_thick], center = false);
            }
        }
        
        // Gel platform (solid)
        translate([outer_x/2 - plat_half_x, 0, floor_thick]) {
            cube([platform_length, inner_y, platform_thickness], center = false);
        }
    }
    
    // Drill electrode wire holes through end walls
    for (x_pos = [wall_thick, outer_x - wall_thick]) {
        translate([x_pos, 0, wire_hole_z]) {
            rotate([90, 0, 0]) {
                cylinder(d = wire_hole_dia, h = outer_y + 0.1, center = true);
            }
        }
    }
}

tank();