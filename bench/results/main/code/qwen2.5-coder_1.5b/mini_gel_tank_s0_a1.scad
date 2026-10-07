// Define dimensions
$fn = 64; // For curved shapes

// Tank dimensions
X = 120;
Y = 70;
Z = 40;

// Wall thickness
wall_thickness = 3;

// Floor thickness
floor_thickness = 3;

// Platform dimensions
platform_length = X / 2;
platform_width = Y;
platform_height = 60;

// Hole diameter
hole_diameter = 2;

// Hole depth
hole_depth = 10;

// Tank bottom division height
division_height = Z - floor_thickness - platform_height;

// Calculate hole positions
hole_positions = [
    [X / 4, 0, 30],
    [3 * X / 4, 0, 30]
];

// Create the tank
tank = cube([X + wall_thickness * 2, Y + wall_thickness * 2, Z + floor_thickness * 2]);

// Add walls
walls = [
    translate([-wall_thickness, -wall_thickness, -floor_thickness]) * cylinder(r=wall_thickness, h=X + wall_thickness),
    translate([-wall_thickness, -wall_thickness, Z + floor_thickness]) * cylinder(r=wall_thickness, h=Y + wall_thickness),
    translate([X + wall_thickness, -wall_thickness, -floor_thickness]) * cylinder(r=wall_thickness, h=X + wall_thickness),
    translate([X + wall_thickness, Y + wall_thickness, -floor_thickness]) * cylinder(r=wall_thickness, h=Y + wall_thickness)
];

// Add floor
floor = translate([-wall_thickness, -wall_thickness, -floor_thickness]) * cube([X + wall_thickness * 2, Y + wall_thickness * 2, floor_thickness]);

// Add platform
platform = translate([0, Y / 2, division_height]) * cylinder(r=platform_width / 2, h=platform_height);

// Add holes
holes = for (i = [0:1], j = [0:1]) {
    translate(hole_positions[i][0], hole_positions[i][1], hole_positions[i][2] + hole_depth) * cylinder(diameter=hole_diameter, h=hole_depth)
};

// Combine all parts
buffer_tank = union(
    tank,
    walls,
    floor,
    platform,
    holes
);

// Render the buffer tank
render(buffer_tank);