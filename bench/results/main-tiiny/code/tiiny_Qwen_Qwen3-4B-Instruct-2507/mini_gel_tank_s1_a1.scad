// Buffer tank for mini horizontal gel-electrophoresis box
// Dimensions in millimeters

// Outer dimensions of the tank
outer_X = 120;
outer_Y = 70;
outer_Z = 40;

// Wall and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Platform dimensions (inner dimensions)
platform_length_X = 60;
platform_centered_X = true;
platform_height_above_floor = 10;  // 10 mm above inner floor

// Electrode holes: 2 mm diameter, along X at y=0, z=30
hole_diameter = 2;
hole_position_z = 30;
hole_position_y = 0;

// Inner dimensions (after subtracting walls and floor)
inner_X = outer_X - 2 * wall_thickness;
inner_Y = outer_Y - 2 * wall_thickness;
inner_Z = outer_Z - wall_thickness - floor_thickness;

// Create the tank as a hollow rectangular box with walls and floor
// Start with outer cube, subtract inner volume (walls and floor)

tank = difference() {
    cube([outer_X, outer_Y, outer_Z], center=true);
    cube([inner_X, inner_Y, outer_Z], center=true);  // remove inner volume in Z
    cube([outer_X, inner_Y, wall_thickness], center=true);  // remove front/back walls
    cube([inner_X, outer_Y, wall_thickness], center=true);  // remove left/right walls
    cube([inner_X, inner_Y, floor_thickness], center=true);  // remove floor
};

// Create the raised platform
// Platform spans full Y (inner_Y), 60 mm in X (centered), 10 mm high
// Positioned at z = 0 to 10 mm (above inner floor)

platform = cube([
    platform_length_X,
    inner_Y,
    platform_height_above_floor
], center=true);

// Translate platform to center it in X and at y=0
// Center in X: from (inner_X/2 - 30) to (inner_X/2 + 30)
platform_translated = translate([
    inner_X / 2 - platform_length_X / 2,
    0,
    0
]) * platform;

// Add platform to tank
tank = union() {
    tank;
    platform_translated;
};

// Drill electrode holes in the end walls (at x=0 and x=outer_X)
// Holes are 2 mm diameter, along X at y=0, z=30

// Hole 1: in left wall (x=0)
// Cylinder of diameter 2 mm, length 30 mm in X, at y=0, z=30
// Must be within the tank walls

// First, define the hole as a cylinder
hole = cylinder(r=1, h=30, center=true, $fn=64);

// Translate to position: at x=0, y=0, z=30
hole_left = translate([0, 0, 30]) * hole;

// Hole 2: in right wall (x=outer_X)
hole_right = translate([outer_X, 0, 30]) * hole;

// Subtract both holes from the tank
tank = difference() {
    tank;
    hole_left;
    hole_right;
};

// Final output: the buffer tank with platform and electrode holes