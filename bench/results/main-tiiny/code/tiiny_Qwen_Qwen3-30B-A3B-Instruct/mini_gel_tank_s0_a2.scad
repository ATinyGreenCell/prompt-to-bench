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

// Set resolution for smooth curves
$fn = 64;

// Main tank body (outer box with walls and floor)
// Build from z = 0 to z = 40, centered in X and Y at origin (0,0) for symmetry
// The tank is 120 mm X, 70 mm Y, 40 mm Z, with 3 mm walls and 3 mm floor
// So the inner dimensions are:
inner_x = outer_x - 2 * wall_thickness;  // 114 mm
inner_y = outer_y - 2 * wall_thickness;  // 64 mm
inner_z = outer_z - floor_thickness;     // 37 mm

// Platform for gel tray (raised solid in the middle)
// Platform is 60 mm long in X, centered in X (so from X = -30 to +30 relative to center)
// Platform is 70 mm wide (full Y), so spans Y = -35 to +35
// Platform top is at z = 13 (since floor is 3 mm thick → z = 3 is floor top, platform top at z = 13)
// Platform is 3 mm thick (same as wall)

// We'll build everything centered at origin (0,0,0) for symmetry, but ensure bottom is at z = 0

module tank_body() {
    // Outer box: from z = 0 to z = 40
    // X: -60 to +60 (120 mm)
    // Y: -35 to +35 (70 mm)
    // Z: 0 to 40
    cube([outer_x, outer_y, outer_z], center = false);

    // Cut out the inner cavity (to form walls and floor)
    difference() {
        cube([outer_x, outer_y, outer_z], center = false);
        
        // Inner cavity: from z = 0 to z = 37 mm (since floor is 3 mm thick → inner height = 37 mm)
        // X: from -60 to +60 → inner_x = 114 → so from -57 to +57
        // Y: from -35 to +35 → inner_y = 64 → so from -32 to +32
        // Z: from 0 to 37
        translate([
            -inner_x / 2,  // -57
            -inner_y / 2,  // -32
            0
        ]) {
            cube([inner_x, inner_y, inner_z], center = false);
        }
    }
}

// Platform for gel tray (raised solid in the middle)
// Centered in X: from -platform_length/2 to +platform_length/2 → -30 to +30
// Centered in Y: from -35 to +35 (full Y)
// Height: 3 mm thick, sitting on floor at z = 3, so bottom at z = 3, top at z = 13
module platform() {
    translate([
        0,  // centered in X
        0,  // centered in Y
        floor_thickness  // bottom at z = 3
    ]) {
        cube([platform_length, platform_width, wall_thickness], center = false);
    }
}

// Horizontal holes through end walls (X=±60) at y=0, z=30
// The hole is drilled through the end wall (in X direction), so:
// - Left hole: at X = -60 (left face of tank), Y = 0, Z = 30
// - Right hole: at X = +60 (right face of tank), Y = 0, Z = 30
// The wall is 3 mm thick → so the hole is a cylinder of length 3 mm (in X direction), drilled from the outer face inward
// We drill from X = -60 to X = -57 (in +X direction) for the left hole
// Similarly, from X = +60 to X = +57 for the right hole

module electrode_holes() {
    // Left hole: at X = -60 (left wall face), Y = 0, Z = 30
    // Drill from X = -60 to X = -57 (3 mm inward)
    translate([
        -60,  // X = -60 (left face)
        0,    // Y = 0
        hole_z  // Z = 30
    ]) {
        cylinder(h = wall_thickness, r = hole_radius, center = false, $fn = 64);
    }

    // Right hole: at X = +60 (right wall face), Y = 0, Z = 30
    // Drill from X = +60 to X = +57 (3 mm inward)
    translate([
        60,   // X = +60 (right face)
        0,    // Y = 0
        hole_z  // Z = 30
    ]) {
        cylinder(h = wall_thickness, r = hole_radius, center = false, $fn = 64);
    }
}

// Assemble the complete buffer tank, with base at z = 0 and centered in X and Y
// All parts are built from z = 0 to z = 40, with bottom at z = 0
// The tank is 120 mm X, 70 mm Y, 40 mm Z, walls 3 mm, floor 3 mm
// Platform is 60 mm X, centered, 3 mm thick, top at z = 13
// Holes at X = ±60, Y = 0, Z = 30, 2 mm diameter, drilled 3 mm into tank

tank_body();
platform();
electrode_holes();