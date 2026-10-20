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
platform_width_Y = 70; // spans full inner Y
platform_height = 10; // 10 mm above inner floor
platform_z_position = 13; // z = 13 mm (inner floor + 10 mm platform)

// Electrode hole: 2 mm diameter, horizontal, along X, at y=0, z=30
hole_diameter = 2;
hole_depth = 3; // hole goes through the wall thickness
hole_z_position = 30; // at z = 30 mm (within the tank)

// Inner dimensions (after subtracting walls and floor)
inner_X = outer_X - 2 * wall_thickness;
inner_Y = outer_Y - 2 * wall_thickness;
inner_Z = outer_Z - wall_thickness - floor_thickness;

// Create the outer tank base (open top, with walls and floor)
// Start with the outer rectangular box
tank = cube([outer_X, outer_Y, outer_Z], center=true);

// Subtract the inner space to create walls and floor
// First, create the inner volume (without walls and floor)
inner_volume = cube([inner_X, inner_Y, inner_Z], center=true);

// Create the platform: raised structure at the center in X, full Y, 10 mm high
// Platform is centered in X, spans full Y, at z = 13 (inner floor + 10 mm)
// It is built from the inner space, so we subtract it from the tank
// But we will build it as a solid and use difference

// Define platform
platform = cube([platform_length_X, platform_width_Y, platform_height], center=true);
// Center the platform in X: from -platform_length_X/2 to +platform_length_X/2
// Centered in Y: from -platform_width_Y/2 to +platform_width_Y/2
// Height from z = 0 to z = 10 (inner floor is at z=13, so platform starts at z=13)

// Translate platform to correct position: centered in X, full Y, at z=13
// Platform is centered in X: from -30 to +30 mm (60 mm long)
// Full Y: from -35 to +35 mm (70 mm wide)
// Height: from z=13 to z=23 (10 mm high)

// Translate platform to correct position
platform_translated = translate([0, 0, 13]) 
    cube([platform_length_X, platform_width_Y, platform_height], center=true);

// Create the two buffer chambers: one at each end, connected above the platform
// The tank has walls and floor, so we need to remove the platform and the end chambers

// First, create the tank with walls and floor (outer box)
// Then subtract the platform and the end chambers (but we're building the platform as a solid)

// Instead, build the tank as the outer box minus the inner volume
// Then add the platform as a raised structure

// Start with the outer tank
tank_base = cube([outer_X, outer_Y, outer_Z], center=true);

// Subtract the inner volume (to leave walls and floor)
// The inner volume is a box of size [inner_X, inner_Y, inner_Z]
inner_box = cube([inner_X, inner_Y, inner_Z], center=true);
tank_with_walls_and_floor = difference() {
    tank_base;
    inner_box;
};

// Now add the platform: raised structure at z=13, centered in X, full Y
// The platform is 60 mm long in X, 70 mm in Y, 10 mm high
// It is at z=13 to z=23
// We need to ensure it is centered in X and spans full Y

// Add platform
platform_added = translate([0, 0, 13]) 
    cube([platform_length_X, platform_width_Y, platform_height], center=true);

// Now drill holes in each end wall (at y=0, z=30) for electrode wires
// Holes are 2 mm diameter, horizontal, along X, at y=0, z=30
// The hole goes through the wall thickness (3 mm), so from z=27 to z=30 (since z=30 is top of wall)

// First, define the hole as a cylinder in the X direction
// The hole is at y=0, z=30, and goes from z=27 to z=30 (3 mm depth)
// It is 2 mm in diameter, along X

// Create a cylinder for the hole at the left end wall (x=0)
// The hole is in the wall at x=0, y=0, z=27 to z=30
// It is 2 mm in diameter, along X (so it spans X)

// We need to create a cylinder that is 2 mm in diameter, 3 mm deep, at y=0, z=30, and extends along X
// But the hole is in the end wall, so it is at x=0, and spans X from x=0 to x=2 (for example)

// Actually, the hole is drilled through the wall at the end, so it goes from x=0 to x=outer_X, but only in the wall
// But the wall is 3 mm thick, so the hole goes from z=27 to z=30

// The hole is 2 mm in diameter, so we create a cylinder of diameter 2 mm, depth 3 mm, at y=0, z=30
// But it must be in the wall at x=0 or x=outer_X

// We will drill two holes: one at left end (x=0), one at right end (x=outer_X)

// Hole at left end wall: at x=0, y=0, z=27 to z=30
// Hole at right end wall: at x=outer_X, y=0, z=27 to z=30

// Create a cylinder for one hole
hole_cylinder = cylinder(d=hole_diameter/2, h=hole_depth, center=true, $fn=64);

// Translate to left end wall: at x=0, y=0, z=27 to z=30
// The hole is in the wall, so we place it at x=0, y=0, z=27 to z=30
// But the wall is at x=0 to x=3 mm, so we place the hole at x=0, y=0, z=27 to z=30

// Translate to left end wall
hole_left = translate([0, 0, 27]) 
    rotate([90, 0, 0]) // rotate to make it along X
    rotate([0, 0, 90]) // rotate to make it along X
    cylinder(d=hole_diameter/2, h=hole_depth, center=true, $fn=64);

// Actually, we need to place the hole in the wall at x=0, y=0, z=27 to z=30
// The hole is 2 mm in diameter, 3 mm deep, and goes along X
// So we create a cylinder with diameter 2 mm, depth 3 mm, at y=0, z=27 to z=30, and along X

// Correct: the hole is drilled in the wall at x=0, y=0, z=27 to z=30, and spans X
// So we create a cylinder with diameter 2 mm, depth 3 mm, and it is aligned with X-axis

// To create a hole in the wall at x=0, y=0, z=27 to z=30, we use:
// translate([0, 0, 27]) and rotate to align with X-axis

// But the wall is at x=0 to x=3 mm, so we place the hole at x=0, y=0, z=27 to z=30
// The hole is 2 mm in diameter, so we create a cylinder of diameter 1 mm (radius 1 mm), depth 3 mm

// Correct: we create a cylinder of diameter 2 mm, depth 3 mm, at y=0, z=27 to z=30, and aligned with X-axis

// Translate to the left end wall: at x=0, y=0, z=27
// The cylinder will extend in X (from x=0 to x=2 mm), and in Z (from z=27 to z=30)

// But the wall is only 3 mm thick, so we place the hole at z=27 to z=30

// Create the hole at left end wall
hole_left = translate([0, 0, 27]) 
    rotate([0, 0, 90]) // rotate to align with X-axis
    cylinder(d=hole_diameter/2, h=hole_depth, center=true