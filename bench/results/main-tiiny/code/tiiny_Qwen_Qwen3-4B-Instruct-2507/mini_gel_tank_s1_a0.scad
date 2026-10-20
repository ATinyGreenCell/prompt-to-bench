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

// Create the outer tank (open top, with walls and floor)
// Start with the base and walls

// Floor (bottom of tank)
floor = cube([inner_X, inner_Y, floor_thickness], center=true);

// Side walls (front, back, left, right)
// Front and back walls (Y direction)
front_back_wall = cube([wall_thickness, inner_Y, outer_Z], center=true);
left_right_wall = cube([inner_X, wall_thickness, outer_Z], center=true);

// Top is open, so no top cube

// Combine floor and walls into the full tank structure
tank = union() {
    floor;
    front_back_wall;
    left_right_wall;
};

// Create the raised platform in the middle
// Platform spans full inner Y (width), 60 mm in X (centered), 10 mm above inner floor

// Inner platform dimensions
platform_width_Y = inner_Y;
platform_center_X = platform_length_X / 2;
platform_center_X_offset = (inner_X - platform_length_X) / 2;

// Platform base at z = inner_Z - floor_thickness + platform_height_above_floor
// Inner floor is at z = 0, so platform starts at z = 0 + platform_height_above_floor
// The platform is built from the inner floor up

// Platform height is 10 mm above inner floor
platform_height = platform_height_above_floor;

// Platform base: centered in X, spans full Y, height = platform_height
platform = cube([
    platform_length_X,
    platform_width_Y,
    platform_height
], center=true);

// Translate platform to correct position: centered in X, at y=0, z=platform_height
// Centered in X: from (inner_X/2 - platform_length_X/2) to (inner_X/2 + platform_length_X/2)
// So center at X = inner_X/2 - platform_length_X/2 + platform_length_X/2 = inner_X/2
// But we want it centered in the X direction, so centered at X = inner_X/2
// Y spans full inner_Y, so from 0 to inner_Y
// Z starts at 0 (inner floor) and goes up to platform_height

// Translate platform to center it in X and at Y=0
platform_translated = translate([
    inner_X / 2 - platform_length_X / 2,
    0,
    0
]) * platform;

// Now add the platform to the tank
// But we must ensure it is built on top of the inner floor

// First, create the full tank with walls and floor
tank = cube([outer_X, outer_Y, outer_Z], center=true);

// Now subtract the platform from the tank? No — we want the platform to be inside the tank.

// Actually, we are building the tank as a hollow structure with walls and floor.
// We need to build the tank with the inner space, and then add the platform.

// Better approach: build the tank as a hollow rectangular box with walls and floor.
// Then, add the platform as a solid block inside.

// Build the tank as a hollow box with walls and floor
tank = difference() {
    cube([outer_X, outer_Y, outer_Z], center=true);
    // Subtract the inner space
    cube([inner_X, inner_Y, outer_Z - wall_thickness], center=true);
    cube([outer_X, inner_Y, wall_thickness], center=true);  // front/back walls
    cube([inner_X, outer_Y, wall_thickness], center=true);  // left/right walls
    cube([inner_X, inner_Y, floor_thickness], center=true);  // floor
};

// Actually, simpler: build the tank as a solid with walls and floor, then subtract the inner space.

// Correct construction: start with full outer cube, subtract the inner space
tank = difference() {
    cube([outer_X, outer_Y, outer_Z], center=true);
    // Subtract the inner part: walls and floor
    cube([inner_X, inner_Y, outer_Z], center=true);  // inner volume
    // But we need to subtract only the walls and floor
    // So subtract the inner volume, and also subtract the top (open)
    // We don't need to subtract top because it's open
};

// Actually, correct way: build the tank as a hollow rectangular box with walls and floor
// The tank is defined as:
// - Full outer box
// - Minus the inner space (inner_X x inner_Y x inner_Z)
// - Minus the top (open, so we don't subtract it)

// But we also need to remove the top, so we don't include it.

// So the tank is:
// Full outer cube minus the inner volume (inner_X x inner_Y x inner_Z)
// But we also need to remove the top, so we don't include the top.

// However, the top is open, so we don't need to remove it — we just build the walls and floor.

// Final tank construction:
// Start with outer cube
// Subtract the inner volume (inner_X x inner_Y x inner_Z)
// But also subtract the top (to make it open)

// Actually, we can build the tank as:
// 1. Outer cube
// 2. Minus a cube of inner_X x inner_Y x outer_Z (to remove the inner volume)
// 3. Minus the top (z > 0) — but we don't want to remove the top

// Since the top is open, we just build the walls and floor.

// So the tank is:
// Outer cube minus inner cube (inner_X x inner_Y x inner_Z)

tank = difference() {
    cube([outer_X, outer_Y, outer_Z], center=true);
    cube([inner_X, inner_Y, inner_Z], center=true);
};

// Now add the platform
// Platform is solid, 60 mm in X, full Y, 10 mm high, centered in X, at z = 13 (above inner floor)

// Inner floor is at z=0, so platform starts at z=0 and goes to z=10
// Platform is centered in X: from (inner_X/2 - 30) to (inner_X/2 + 30)

// Translate platform to center in X, at y=0, z=0 to z=10
platform_translated = translate([
    inner_X / 2 - platform_length_X / 2,
    0,
    0
]) * cube([
    platform_length_X,
    inner_Y,
    platform_height_above_floor
]);

// Now add platform to tank
tank = union() {
    tank;
    platform_translated;
};

// Now drill electrode holes in each end wall (at y=0, z=30)
// Holes are 2 mm diameter, along X, at y=0, z=30

// First, create a hole in the left wall (at x=0)
// The hole is in the wall at x=0, y=0, z=30, going along X

// The hole is 2 mm diameter, 30 mm in z, and along X

// We need to create a cylinder of diameter 2 mm, length along X, at y=0, z=30

// But the tank is defined with walls, so we need to cut a hole in the wall

// We will create a cylinder of diameter 2 mm, length 30 mm in X, at y=0, z=30

// But the wall is at x=0, so we need to cut a hole in the wall at x=0, y=0, z=30

// The hole is in the wall at x=0, so we need to subtract a cylinder in that region

// The hole is 2 mm in diameter, so radius 1 mm
// It is along X, so we need to define a cylinder that spans X from 0 to 30 mm, at y=0, z=30

// But the wall is only 3 mm thick, and we are at z=30, which is within the tank height

// The hole is in the end wall (at x=0 or x=outer_X)

// We will drill in both end walls: at x=0 and x=outer_X

// First, hole at x=0, y=0, z=30
// Create a cylinder of diameter 2 mm, length 30 mm in X, at y=0, z=30

// But we must ensure the cylinder is within the tank

// The tank has walls at x=0 and x=outer_X, so we can cut a hole in the wall at