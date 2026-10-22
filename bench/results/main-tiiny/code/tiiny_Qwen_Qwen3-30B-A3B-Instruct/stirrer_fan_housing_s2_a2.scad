// Dimensions for DIY magnetic stirrer housing
$fn = 64;

// Overall dimensions
outer_width = 90;        // X dimension
outer_depth = 90;        // Y dimension
top_thickness = 2;       // Z thickness of top plate
wall_height = 40;        // Height of walls from top plate
wall_thickness = 2.5;    // Thickness of side walls

// Screw hole parameters
screw_diameter = 4.5;    // Diameter of screw holes
screw_pattern_diameter = 71.5; // Diagonal distance between screw holes (square pattern)

// Notch for power cable
notch_width = 12;      // Width of notch in wall
notch_depth = 8;        // Depth of notch from open edge (z = 32 to 40)

// Generate top plate (z = 0 to 2), centered at origin
top_plate = cube([outer_width, outer_depth, top_thickness], center = true);

// Generate walls (z = 2 to 40), each as a separate cube and positioned correctly
// Front wall (Y = -45 to -45 + wall_thickness, X = -45 to 45)
front_wall = cube([outer_width, wall_thickness, wall_height - top_thickness], center = true);
front_wall = translate([0, -outer_depth/2 + wall_thickness/2, top_thickness + (wall_height - top_thickness)/2]) * front_wall;

// Back wall (Y = 45 - wall_thickness to 45)
back_wall = cube([outer_width, wall_thickness, wall_height - top_thickness], center = true);
back_wall = translate([0, outer_depth/2 - wall_thickness/2, top_thickness + (wall_height - top_thickness)/2]) * back_wall;

// Left wall (X = -45 to -45 + wall_thickness, Y = -45 to 45)
left_wall = cube([wall_thickness, outer_depth, wall_height - top_thickness], center = true);
left_wall = translate([-outer_width/2 + wall_thickness/2, 0, top_thickness + (wall_height - top_thickness)/2]) * left_wall;

// Right wall (X = 45 - wall_thickness to 45)
right_wall = cube([wall_thickness, outer_depth, wall_height - top_thickness], center = true);
right_wall = translate([outer_width/2 - wall_thickness/2, 0, top_thickness + (wall_height - top_thickness)/2]) * right_wall;

// Combine walls into a single solid
walls = union() {
    front_wall;
    back_wall;
    left_wall;
    right_wall;
}

// Combine top plate and walls to form housing
housing = union() {
    top_plate;
    walls;
}

// Cut screw holes in top plate
// Four holes on a square pattern, centered at origin
screw_hole = cylinder(h = top_thickness + 2, r = screw_diameter / 2, center = true);
screw_hole = translate([0, 0, -1]) * screw_hole; // Extend below for clean cut

// Generate four screw holes at corners of square
screw_holes = union();
for (i = [0:3]) {
    angle = i * 90;
    x = (screw_pattern_diameter / 2) * cos(angle * pi / 180);
    y = (screw_pattern_diameter / 2) * sin(angle * pi / 180);
    screw_holes = union() {
        screw_holes;
        translate([x, y, 0]) * screw_hole;
    }
}

// Subtract screw holes from housing
housing = difference() {
    housing;
    screw_holes;
}

// Cut notch in front wall for power cable
// Notch is 12 mm wide, centered along the front wall (Y direction), from z = 32 to 40 (8 mm deep)
notch_cut = cube([notch_width, wall_thickness, notch_depth], center = true);
notch_cut = translate([0, -outer_depth/2 + wall_thickness/2, wall_height - notch_depth/2]) * notch_cut;

// Subtract notch from housing
housing = difference() {
    housing;
    notch_cut;
}

// Final housing model
housing;