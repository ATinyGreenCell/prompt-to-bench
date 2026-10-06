// DIY Magnetic Stirrer Housing
// Upside-down open box for 80mm PC fan
// Print orientation: top plate on bed (z=0-2), walls rising to z=40

// Dimensions (all in mm)
outer_size = 90;              // Outer dimension 90 x 90 mm
top_plate_thickness = 2;      // Top plate thickness
wall_thickness = 2.5;         // Wall thickness on all sides
total_height = 40;            // Total height from bed to open edge
mounting_hole_diameter = 4.5; // M4 screw hole diameter
mounting_hole_pattern = 71.5; // Mounting hole square pattern (center-to-center)
cable_notch_width = 12;       // Power cable notch width
cable_notch_depth = 8;        // Notch depth from open edge

// Resolution for curves
$fn = 64;

// Derived dimensions
inner_size = outer_size - 2 * wall_thickness;  // 85 mm inner cavity
wall_height = total_height - top_plate_thickness;  // 38 mm
hole_offset = mounting_hole_pattern / 2;  // 35.75 mm from center to each hole

difference() {
    // Create outer box shell
    union() {
        // Top plate: 90 x 90 x 2 mm at z = 0 to 2
        translate([0, 0, top_plate_thickness / 2])
            cube([outer_size, outer_size, top_plate_thickness], center = true);
        
        // Walls: 90 x 90 outer, rising from z = 2 to z = 40
        translate([0, 0, top_plate_thickness + wall_height / 2])
            cube([outer_size, outer_size, wall_height], center = true);
    }
    
    // Cut out interior cavity (hollow the walls)
    // Creates 85 x 85 mm cavity from z = 2 to z = 40
    translate([0, 0, top_plate_thickness + wall_height / 2])
        cube([inner_size, inner_size, wall_height + 0.1], center = true);
    
    // Drill four M4 mounting holes through top plate
    // 71.5 mm square pattern, centered on plate
    for (dx = [-1, 1]) {
        for (dy = [-1, 1]) {
            translate([dx * hole_offset, dy * hole_offset, -0.5])
                cylinder(h = top_plate_thickness + 1, r = mounting_hole_diameter / 2, $fn = 64);
        }
    }
    
    // Power cable notch in +Y wall
    // 12 mm wide (X direction), centered, 8 mm deep from open edge (z = 32 to z = 40)
    notch_z_center = total_height - cable_notch_depth / 2;
    translate([0, outer_size / 2 + 0.5, notch_z_center])
        cube([cable_notch_width, wall_thickness + 1, cable_notch_depth], center = true);
}