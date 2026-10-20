// Buffer tank for mini horizontal gel-electrophoresis box
// Outer dimensions: 120 mm (X) x 70 mm (Y) x 40 mm (Z)
// Wall thickness: 3 mm
// Floor thickness: 3 mm
// Platform: 60 mm (X) x 70 mm (Y) x 10 mm (Z), centered in X, z = 13

// Dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thickness = 3;
floor_thickness = 3;
platform_x = 60;
platform_y = 70;
platform_z = 10;
platform_z_offset = 13;
hole_diameter = 2;
hole_z_position = 30;

// Main tank body (outer dimensions)
tank = [outer_x, outer_y, outer_z];

// Inner dimensions (accounting for walls)
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// Platform position (centered in X)
platform_x_pos = (outer_x - platform_x) / 2;

// Main tank
main_tank = union() {
    // Outer shell
    cube(tank, center = false);
    
    // Inner cavity
    translate([wall_thickness, wall_thickness, floor_thickness]) {
        cube([inner_x, inner_y, inner_z], center = false);
    }
};

// Platform
platform = translate([platform_x_pos, 0, platform_z_offset]) {
    cube([platform_x, platform_y, platform_z], center = false);
};

// Holes for electrode wires
hole = cylinder(h = 1, d = hole_diameter, center = true, $fn = 64);

// Left hole
left_hole = translate([0, 0, hole_z_position]) {
    rotate([0, 0, 90]) {
        hole;
    }
};

// Right hole
right_hole = translate([outer_x, 0, hole_z_position]) {
    rotate([0, 0, 90]) {
        hole;
    }
};

// Final assembly
assembly = union() {
    main_tank;
    platform;
    left_hole;
    right_hole;
};

// Render the final part
assembly;