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

platform_start_x = (inner_X - platform_X) / 2;
platform_start_y = wall_thick;
platform_start_z = platform_top_z - platform_thick;

difference() {
    // Outer shape (centered on origin)
    cube([outer_X, outer_Y, outer_Z], center=true);
    
    // Inner cavity (centered on origin)
    cube([inner_X, inner_Y, inner_Z + 0.01], center=true);
    
    // Platform
    translate([platform_start_x, platform_start_y, platform_start_z]) {
        cube([platform_X, platform_Y, platform_thick]);
    }
    
    // Electrode wire holes
    translate([0, 0, hole_z]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_dia, h = outer_X + 1, $fn = 64);
        }
    }
}