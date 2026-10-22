// --- Buffer tank for mini horizontal gel-electrophoresis box ---
// Print orientation: resting on XY plane at z = 0, building upward (+Z)
// Centre on origin in X and Y

// Outer dimensions
outer_X = 120;   // mm, X dimension
outer_Y = 70;    // mm, Y dimension
outer_Z = 40;    // mm, Z dimension

// Wall and floor thickness
wall_thick = 3;  // mm
floor_thick = 3; // mm

// Platform dimensions
platform_length = 60;  // mm, X dimension (centred)
platform_top_z = 13;   // mm, top of platform above inner floor
platform_thickness = platform_top_z - floor_thick; // 10 mm

// Electrode wire holes
hole_dia = 2;    // mm, diameter
hole_z = 30;     // mm, height of hole centre

// Inner dimensions
inner_X = outer_X - 2 * wall_thick;
inner_Y = outer_Y - 2 * wall_thick;

// Platform half-length
plat_half_X = platform_length / 2;

// --- Build the tank ---
module tank() {
    union() {
        // Floor
        translate([0, 0, floor_thick/2]) {
            cube([outer_X, outer_Y, floor_thick], center = true);
        }
        
        // Four walls
        // Front and back walls (along X)
        translate([0, outer_Y/2 - wall_thick/2, outer_Z/2]) {
            cube([outer_X, wall_thick, outer_Z], center = true);
        }
        translate([0, -outer_Y/2 + wall_thick/2, outer_Z/2]) {
            cube([outer_X, wall_thick, outer_Z], center = true);
        }
        
        // Left and right walls (along Y)
        translate([outer_X/2 - wall_thick/2, 0, outer_Z/2]) {
            cube([wall_thick, outer_Y, outer_Z], center = true);
        }
        translate([-outer_X/2 + wall_thick/2, 0, outer_Z/2]) {
            cube([wall_thick, outer_Y, outer_Z], center = true);
        }
        
        // Platform (solid, raised)
        translate([0, 0, floor_thick + platform_thickness/2]) {
            cube([platform_length, inner_Y, platform_thickness], center = true);
        }
    }
}

// --- Main assembly ---
tank();

// --- Drill electrode wire holes ---
// Hole at each end wall, along X axis, at y=0, z=30
for (x_pos in [-outer_X/2 + wall_thick/2, outer_X/2 - wall_thick/2]) {
    translate([x_pos, 0, hole_z]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_dia, h = outer_Y + 1, center = true, $fn = 32);
        }
    }
}