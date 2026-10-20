// Dimensions in millimetres
outer_x = 120;
outer_y = 70;
outer_z = 40;

wall_thickness = 3;
floor_thickness = 3;

platform_length = 60;
platform_width = outer_y;  // spans full Y
platform_height_above_floor = 10;  // top of platform at z = 13 (floor at z = 3)

hole_diameter = 2;
hole_radius = hole_diameter / 2;
hole_y = 0;  // along Y=0 edge
hole_z = 30;  // at z = 30

// Inner dimensions
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// Platform is centred in X
platform_x_center = (outer_x - platform_length) / 2;

// Set resolution for smooth curves
$fn = 64;

// Main tank body (outer box with walls and floor)
module tank_body() {
    difference() {
        // Outer box (full size)
        cube([outer_x, outer_y, outer_z], center = true);

        // Remove inner cavity (to create walls and floor)
        translate([0, 0, -outer_z/2 + floor_thickness]) {
            cube([inner_x, inner_y, outer_z - floor_thickness], center = true);
        }
    }
}

// Platform for gel tray (raised solid in the middle)
module platform() {
    translate([
        0,  // centered in Y
        0,  // centered in X (via offset)
        floor_thickness + platform_height_above_floor
    ]) {
        cube([platform_length, platform_width, wall_thickness], center = true);
    }
}

// Horizontal holes through end walls (X=±outer_x/2) at y=0, z=30
module electrode_holes() {
    // Left hole (X = -outer_x/2 + wall_thickness)
    translate([
        -outer_x/2 + wall_thickness + wall_thickness,  // offset to inner face
        0,
        hole_z
    ]) {
        cylinder(h = 2 * wall_thickness, r = hole_radius, center = true);
    }

    // Right hole (X = +outer_x/2 - wall_thickness)
    translate([
        outer_x/2 - wall_thickness - wall_thickness,  // offset to inner face
        0,
        hole_z
    ]) {
        cylinder(h = 2 * wall_thickness, r = hole_radius, center = true);
    }
}

// Assemble the complete buffer tank
tank_body();
platform();
electrode_holes();