$fn = 64;

// Dimensions (mm)
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thick = 3;
floor_thick = 3;
hole_diam = 2;
hole_z = 30;
platform_len = 60;
platform_height = 10;
platform_thick = 2; // Thickness of the solid platform

// Derived Dimensions
inner_floor_z = wall_thick;
platform_top_z = inner_floor_z + platform_height;
platform_bottom_z = platform_top_z - platform_thick;
platform_width = outer_y - 2 * wall_thick; // Spans full inner width

// Floor
floor = cube([outer_x, outer_y, floor_thick], center=true);

// Walls
left_wall = cube([wall_thick, outer_y, outer_z], center=true);
right_wall = cube([wall_thick, outer_y, outer_z], center=true);
front_wall = cube([outer_x, wall_thick, outer_z], center=true);
back_wall = cube([outer_x, wall_thick, outer_z], center=true);

// Platform
platform = cube([platform_len, platform_width, platform_thick], center=true);

// Holes (Cutting shapes)
// Rotate 90 degrees around Y to align hole along X axis
hole_len = wall_thick + 0.1;
left_hole = rotate([0, 90, 0]) cylinder(h=hole_len, r=hole_diam/2, center=true, $fn=32);
right_hole = rotate([0, 90, 0]) cylinder(h=hole_len, r=hole_diam/2, center=true, $fn=32);

// Assembly
difference() {
    union() {
        floor;
        left_wall;
        right_wall;
        front_wall;
        back_wall;
        platform;
    }
    left_hole;
    right_hole;
}