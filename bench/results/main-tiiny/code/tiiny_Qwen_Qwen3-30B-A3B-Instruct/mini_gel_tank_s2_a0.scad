// Dimensions in millimetres
outer_x = 120;
outer_y = 70;
outer_z = 40;

wall_thickness = 3;
floor_thickness = 3;

platform_length = 60;
platform_width = outer_y;  // spans full Y
platform_height_above_floor = 10;  // top at z = 13 (floor at z = 3)

hole_diameter = 2;
hole_radius = hole_diameter / 2;
hole_z = 30;  // z-level of hole center
hole_y = 0;   // along Y=0 (end wall)

// Inner dimensions
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// Platform top at z = 13 (floor at z = 3, so 10 mm above)
platform_top_z = floor_thickness + platform_height_above_floor;

// Platform centered in X
platform_x_start = (outer_x - platform_length) / 2;
platform_x_end = platform_x_start + platform_length;

// Create the main tank body (open top, hollow)
module tank() {
    // Outer box (with floor)
    difference() {
        cube([outer_x, outer_y, outer_z], center = true);
        // Remove inner cavity
        translate([0, 0, -outer_z/2 + inner_z/2]) {
            cube([inner_x, inner_y, inner_z], center = true);
        }
    }
}

// Create the raised platform (solid, centered in X, full Y)
module platform() {
    translate([0, 0, -outer_z/2 + floor_thickness + platform_height_above_floor]) {
        cube([platform_length, platform_width, wall_thickness], center = true);
    }
}

// Create the two end-wall holes (horizontal, along X, at y=0, z=30)
module end_hole() {
    // Hole is horizontal, so we use a cylinder along X
    // Extend slightly beyond the wall to ensure clean cut
    cylinder(r = hole_radius, h = wall_thickness + 1, $fn = 64, center = true);
}

module hole_at_end(x_pos) {
    translate([x_pos, 0, hole_z]) {
        rotate([90, 0, 0]) {
            end_hole();
        }
    }
}

// Main assembly
$fn = 64;

// Build the tank with platform and holes
difference() {
    // Start with the full tank body
    tank();

    // Cut out the platform (so it's hollow except for the solid platform)
    // But we don't want to remove the platform — we want to keep it solid.
    // So instead, we subtract the platform from the tank body only where it's not needed.
    // Actually, we'll build the platform separately and union it.
}

// Union the platform into the tank
union() {
    tank();
    platform();
}

// Now drill the two end holes (through the end walls)
// The holes go through the walls at X = ±(outer_x/2 - wall_thickness) and Y = 0, Z = 30
// We drill from both sides, so we need to cut through the wall at each end

// Left end wall (x = -outer_x/2 + wall_thickness)
hole_at_end(-outer_x/2 + wall_thickness);

// Right end wall (x = +outer_x/2 - wall_thickness)
hole_at_end(outer_x/2 - wall_thickness);