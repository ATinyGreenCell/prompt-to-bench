// DIY magnetic stirrer housing
// 80mm PC case fan housing, upside down open box

// Dimensions
outer_width = 90;      // Outer width in mm
outer_length = 90;     // Outer length in mm
top_thickness = 2;   // Top plate thickness in mm
wall_thickness = 2.5; // Wall thickness in mm
height = 40;           // Total height in mm
screw_hole_diameter = 4.5; // M4 screw hole diameter in mm
screw_pattern = 71.5;   // Screw mounting pattern in mm
cable_notch_width = 12; // Cable notch width in mm
cable_notch_depth = 8; // Cable notch depth in mm

// Main housing block
housing = union() {
    // Top plate
    translate([0, 0, top_thickness/2])
    cube([outer_width, outer_length, top_thickness], center = true);
    
    // Walls
    translate([0, 0, (top_thickness + height)/2])
    union() {
        // Front wall
        translate([0, -outer_length/2 + wall_thickness/2, 0])
        cube([outer_width, wall_thickness, height], center = true);
        
        // Back wall
        translate([0, outer_length/2 - wall_thickness/2, 0])
        cube([outer_width, wall_thickness, height], center = true);
        
        // Left wall
        translate([-outer_width/2 + wall_thickness/2, 0, 0])
        cube([wall_thickness, outer_length, height], center = true);
        
        // Right wall
        translate([outer_width/2 - wall_thickness/2, 0, 0])
        cube([wall_thickness, outer_length, height], center = true);
    }
};

// Screw holes
screw_holes = union() {
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([i * screw_pattern/2, j * screw_pattern/2, top_thickness - 0.01])
            cylinder(h = 2.5, d = screw_hole_diameter, center = true, $fn = 64);
        }
    }
};

// Cable notch
cable_notch = union() {
    translate([0, 0, height - cable_notch_depth])
    cube([cable_notch_width, wall_thickness + 0.02, cable_notch_depth], center = true);
};

// Final part
difference() {
    housing;
    screw_holes;
    cable_notch;
}