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
    union() {
        // Tank walls and floor (hollow box, open at top)
        difference() {
            // Outer block
            cube([outer_x, outer_y, outer_z], center = false);
            
            // Inner cavity (open at top)
            translate([wall_thick, wall_thick, floor_thick]) {
                cube([inner_x, inner_y, outer_z - floor_thick], center = false);
            }
        }
        
        // Gel platform (solid, centered in Y)
        translate([outer_x/2 - plat_half_x, -inner_y/2, floor_thick]) {
            cube([platform_length, inner_y, platform_thickness], center = false);
        }
    }
    
    // Drill electrode wire holes through end walls (X ends) at y = 0
    for (x_pos = [wall_thick, outer_x - wall_thick]) {
        translate([x_pos, 0, wire_hole_z]) {
            rotate([90, 0, 0]) {
                cylinder(d = wire_hole_dia, h = outer_y + 0.1, center = true);
            }
        }
    }
}

tank();