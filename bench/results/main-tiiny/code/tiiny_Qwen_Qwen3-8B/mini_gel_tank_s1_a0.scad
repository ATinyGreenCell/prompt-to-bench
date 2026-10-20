// Dimensions for the buffer tank
tank_outer_length = 120; // X dimension
tank_outer_width = 70;  // Y dimension
tank_outer_height = 40;  // Z dimension
wall_thickness = 3;      // Wall thickness
floor_thickness = 3;    // Floor thickness
platform_length = 60;    // Length of the raised platform
platform_position_y = 0; // Y position of the platform (centered)
platform_top_height = 13; // Z position of the platform top relative to inner floor
platform_height = 10;    // Height of the platform above the inner floor
hole_diameter = 2;      // Diameter of the electrode wire holes
hole_position_y = 0;    // Y position of the holes
hole_position_z = 30;   // Z position of the holes (along X axis)

// Calculate inner dimensions
tank_inner_length = tank_outer_length - 2 * wall_thickness;
tank_inner_width = tank_outer_width - 2 * wall_thickness;
tank_inner_height = tank_outer_height - wall_thickness - floor_thickness;

// Calculate platform position in X
platform_start_x = (tank_outer_length - platform_length) / 2;
platform_end_x = platform_start_x + platform_length;

// Create the main tank body
tank = cube([tank_outer_length, tank_outer_width, tank_outer_height], center=true);

// Create the inner floor
inner_floor = cube([tank_inner_length, tank_inner_width, floor_thickness], center=true);

// Create the platform
platform = cube([platform_length, tank_inner_width, platform_height], 
                center=[false, false, false], 
                pos=[platform_start_x, platform_position_y, -tank_inner_height + platform_top_height]);

// Create the inner walls
inner_walls = union() {
    // Left inner wall
    cube([wall_thickness, tank_inner_width, tank_inner_height - floor_thickness], 
         pos=[-tank_outer_length/2 + wall_thickness, 0, 0]);
    // Right inner wall
    cube([wall_thickness, tank_inner_width, tank_inner_height - floor_thickness], 
         pos=[tank_outer_length/2 - wall_thickness, 0, 0]);
    // Front inner wall
    cube([tank_inner_length, wall_thickness, tank_inner_height - floor_thickness], 
         pos=[0, -tank_outer_width/2 + wall_thickness, 0]);
    // Back inner wall
    cube([tank_inner_length, wall_thickness, tank_inner_height - floor_thickness], 
         pos=[0, tank_outer_width/2 - wall_thickness, 0]);
}

// Create the electrode wire holes
holes = union() {
    // Left hole
    translate([-tank_outer_length/2 + wall_thickness + hole_diameter/2, hole_position_y, hole_position_z]) {
        cylinder(r=hole_diameter/2, h=hole_diameter, $fn=64);
    }
    // Right hole
    translate([tank_outer_length/2 - wall_thickness - hole_diameter/2, hole_position_y, hole_position_z]) {
        cylinder(r=hole_diameter/2, h=hole_diameter, $fn=64);
    }
}

// Combine all parts
final_tank = difference() {
    tank
    inner_floor
    platform
    inner_walls
    holes
}

// Final output
final_tank;