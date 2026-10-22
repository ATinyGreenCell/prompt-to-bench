// DIY Magnetic Stirrer Housing
// Dimensions in mm

// Main dimensions
outer_size = 90;
wall_thickness = 2.5;
top_thickness = 2;
height = 40;

// Screw hole pattern
screw_hole_diameter = 4.5;
screw_pattern_size = 71.5;
screw_pattern_offset = screw_pattern_size / 2;

// Cable notch dimensions
notch_width = 12;
notch_depth = 8; // from top (z = height - notch_depth to height)
notch_z_start = height - notch_depth;

// Compute inner dimensions
inner_size = outer_size - 2 * wall_thickness;

// Resolution
$fn = 64;

module stirrer_housing() {
    // Outer shell (box with walls and top)
    difference() {
        // Main outer box
        translate([0, 0, -0.01]) 
            cube([outer_size, outer_size, height + 0.02]);
        
        // Hollow out the interior (walls + top)
        translate([wall_thickness, wall_thickness, top_thickness]) 
            cube([inner_size, inner_size, height - top_thickness + 0.02]);
        
        // Top plate (keep only top layer)
        translate([0, 0, height - top_thickness]) 
            cube([outer_size, outer_size, top_thickness + 0.02]);
        
        // Remove everything above top plate except the top surface
        translate([0, 0, height]) 
            cube([outer_size, outer_size, 0.01]);
    }
    
    // Top plate (re-add as solid)
    translate([0, 0, 0]) 
        cube([outer_size, outer_size, top_thickness]);
    
    // Screw holes in top plate
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([
                screw_pattern_offset * i,
                screw_pattern_offset * j,
                -0.01
            ]) {
                cylinder(h = top_thickness + 0.02, r = screw_hole_diameter / 2);
            }
        }
    }
    
    // Cable notch in one wall (front wall, centered in X)
    // Front wall is at Y = -outer_size/2 (negative Y)
    translate([
        -outer_size / 2 - 0.01,  // extend past wall
        -notch_width / 2,
        notch_z_start
    ]) {
        cube([
            outer_size + 0.02,  // full width
            notch_width,
            notch_depth + 0.01
        ]);
    }
}

stirrer_housing();