// Buffer tank for mini gel-electrophoresis box

// Dimensions (mm)
outer_x = 120;          // outer width in X
outer_y = 70;           // outer depth in Y
outer_z = 40;           // outer height in Z
wall_t = 3;             // wall thickness
floor_t = 3;            // floor thickness
platform_len_x = 60;    // platform length in X (centered)
platform_top_z = 13;    // platform top height
electrode_hole_d = 2;   // electrode hole diameter
electrode_hole_z = 30;  // electrode hole height

// Calculated dimensions
inner_x = outer_x - 2 * wall_t;
inner_y = outer_y - 2 * wall_t;

// Tank center positions
tank_x_min = -outer_x / 2;
tank_x_max = outer_x / 2;
tank_y_min = -outer_y / 2;
tank_y_max = outer_y / 2;

// Inner cavity positions
inner_x_min = tank_x_min + wall_t;
inner_x_max = tank_x_max - wall_t;
inner_y_min = tank_y_min + wall_t;
inner_y_max = tank_y_max - wall_t;

// Platform dimensions
platform_x_min = -platform_len_x / 2;
platform_z_height = platform_top_z - floor_t;

$fn = 64;

// Main tank body (outer box with inner cavity subtracted)
difference() {
    // Outer box
    translate([tank_x_min, tank_y_min, 0])
        cube([outer_x, outer_y, outer_z]);
    
    // Inner cavity (open top)
    translate([inner_x_min, inner_y_min, floor_t])
        cube([inner_x, inner_y, outer_z - floor_t + 1]);
    
    // Left electrode hole (through left end wall at X = -60)
    translate([-61, 0, electrode_hole_z])
        rotate([0, 90, 0])
            cylinder(h = 5, r = electrode_hole_d / 2);
    
    // Right electrode hole (through right end wall at X = 60)
    translate([56, 0, electrode_hole_z])
        rotate([0, 90, 0])
            cylinder(h = 5, r = electrode_hole_d / 2);
}

// Raised platform for gel tray
translate([platform_x_min, inner_y_min, floor_t])
    cube([platform_len_x, inner_y, platform_z_height]);