// Buffer tank for mini horizontal gel-electrophoresis box
outer_X = 120;          // Outer length (X)
outer_Y = 70;           // Outer width (Y)
outer_Z = 40;           // Outer height (Z)
wall_thick = 3;         // Wall thickness
floor_thick = 3;        // Floor thickness
platform_X = 60;        // Platform length in X
platform_top_z = 13;    // Platform top Z position
platform_thick = 2;     // Platform thickness
hole_dia = 2;           // Electrode wire hole diameter
hole_z = 30;            // Electrode wire hole Z position

inner_X = outer_X - 2 * wall_thick;
inner_Y = outer_Y - 2 * wall_thick;
inner_Z = outer_Z - floor_thick;
platform_Y = inner_Y;

// Platform position (centered in X, spans full inner width in Y)
platform_start_x = (outer_X - platform_X) / 2;  // Centered in the tank
platform_start_y = wall_thick;
platform_start_z = platform_top_z - platform_thick;

difference() {
    // Outer shape (bottom at z = 0)
    cube([outer_X, outer_Y, outer_Z], [0, 0, 0]);
    
    // Inner cavity (bottom at z = floor_thick)
    translate([wall_thick, wall_thick, floor_thick]) {
        cube([inner_X, inner_Y, inner_Z]);
    }
    
    // Platform
    translate([platform_start_x, platform_start_y, platform_start_z]) {
        cube([platform_X, platform_Y, platform_thick]);
    }
    
    // Electrode wire holes (along X-axis, through end walls)
    translate([0, 0, hole_z]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_dia, h = outer_X + 1, $fn = 64);
        }
    }
}