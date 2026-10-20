// Dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thickness = 3;
floor_thickness = 3;
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;
platform_x = 60;
platform_y = inner_y;
platform_z_bottom = floor_thickness;
platform_z_top = 13;
platform_height = platform_z_top - platform_z_bottom;
hole_diameter = 2;
hole_radius = hole_diameter / 2;
hole_z = 30;
hole_length = outer_x + 2 * wall_thickness;

// Rendering settings
$fn = 64;

// Define the tank body (outer box minus inner void)
tank = difference() {
    cube([outer_x, outer_y, outer_z]);
    translate([0, 0, floor_thickness])
        cube([inner_x, inner_y, inner_z]);
}

// Define the raised platform
platform = translate([0, 0, platform_z_bottom])
    cube([platform_x, platform_y, platform_height]);

// Define the electrode hole (cylinder along X axis)
hole = translate([0, 0, hole_z])
    rotate([0, 90, 0])
    cylinder(r=hole_radius, h=hole_length, center=true);

// Combine tank and platform
final_tank = union() {
    tank;
    platform;
}

// Subtract the hole from the final tank
result = difference() {
    final_tank;
    hole;
}

// Render the result
result;