// Dimensions (mm)
top_plate_thickness = 2;
wall_thickness = 2.5;
wall_height = 40;
outer_size = 90;
screw_hole_dia = 4.5;
screw_pattern_size = 71.5;
cable_notch_width = 12;
cable_notch_depth = 8;

// Derived dimensions
inner_size = outer_size - 2 * wall_thickness;
half_outer = outer_size / 2;
half_pattern = screw_pattern_size / 2;

$fn = 64;

difference() {
    // Main housing body
    union() {
        // Top plate (rests on bed, z=0 to 2)
        translate([0, 0, top_plate_thickness/2])
            cube([outer_size, outer_size, top_plate_thickness], center = true);
        
        // Four walls rising from top plate to z=40
        // Front wall (positive Y)
        translate([0, half_outer - wall_thickness/2, top_plate_thickness + (wall_height - top_plate_thickness)/2])
            cube([outer_size, wall_thickness, wall_height - top_plate_thickness]);
        
        // Back wall (negative Y)
        translate([0, -half_outer + wall_thickness/2, top_plate_thickness + (wall_height - top_plate_thickness)/2])
            cube([outer_size, wall_thickness, wall_height - top_plate_thickness]);
        
        // Left wall (negative X)
        translate([-half_outer + wall_thickness/2, 0, top_plate_thickness + (wall_height - top_plate_thickness)/2])
            cube([wall_thickness, outer_size - 2*wall_thickness, wall_height - top_plate_thickness]);
        
        // Right wall (positive X)
        translate([half_outer - wall_thickness/2, 0, top_plate_thickness + (wall_height - top_plate_thickness)/2])
            cube([wall_thickness, outer_size - 2*wall_thickness, wall_height - top_plate_thickness]);
    }
    
    // Four M4 screw holes through top plate on 71.5 mm square pattern
    for (x = [-half_pattern, half_pattern]) {
        for (y = [-half_pattern, half_pattern]) {
            translate([x, y, -0.5])
                cylinder(r = screw_hole_dia/2, h = top_plate_thickness + 1, center = false);
        }
    }
    
    // Cable notch in one wall (front wall, positive Y)
    // Notch is 12 mm wide, centered along the wall, reaching 8 mm down from open edge (z=32 to z=40)
    translate([0, half_outer - wall_thickness/2, wall_height - cable_notch_depth/2])
        cube([cable_notch_width, wall_thickness + 1, cable_notch_depth], center = true);
}