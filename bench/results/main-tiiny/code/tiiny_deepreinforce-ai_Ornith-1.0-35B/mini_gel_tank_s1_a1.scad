// --- Buffer tank for mini horizontal gel-electrophoresis box ---
// Print orientation: resting on XY plane at z = 0, building upward (+Z)

// Outer dimensions
outer_x = 120;   // mm, X direction
outer_y = 70;    // mm, Y direction
outer_z = 40;    // mm, Z direction

// Wall and floor thickness
wall_thick = 3;  // mm
floor_thick = 3; // mm

// Platform dimensions
platform_length = 60;  // mm, X direction (centred)
platform_top_z = 13;   // mm, top of platform above inner floor

// Electrode wire holes
hole_dia = 2;    // mm, diameter
hole_z = 30;     // mm, height of hole centre

// --- Derived dimensions ---
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;
inner_z = outer_z - floor_thick;

platform_x_start = (inner_x - platform_length) / 2;
platform_y_start = 0; // spans full inner Y
platform_y_end = inner_y;
platform_height = platform_top_z - floor_thick;

// --- Build the part ---
difference() {
    // Outer shell (solid block)
    union() {
        // Main outer box
        cube([outer_x, outer_y, outer_z], center = false);
    }
    
    // Hollow out the interior
    translate([wall_thick, wall_thick, floor_thick]) {
        cube([inner_x, inner_y, inner_z], center = false);
    }
    
    // Electrode wire holes (through end walls)
    // Left end wall hole
    translate([
        0,  // X: starts at left edge
        0,  // Y: centred
        hole_z - hole_dia / 2
    ]) {
        cylinder(
            d = hole_dia,
            h = outer_x + 0.01,  // extend past both walls
            center = false
        );
    }
    
    // Right end wall hole
    translate([
        outer_x,  // X: starts at right edge
        0,
        hole_z - hole_dia / 2
    ]) {
        cylinder(
            d = hole_dia,
            h = outer_x + 0.01,
            center = false
        );
    }
}