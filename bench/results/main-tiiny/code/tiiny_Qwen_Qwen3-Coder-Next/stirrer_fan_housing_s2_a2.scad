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
    // Main outer box (centered on origin at base)
    translate([0, 0, -0.01]) 
        cube([outer_size, outer_size, height + 0.02]);
    
    // Hollow out the interior (walls + top)
    translate([wall_thickness, wall_thickness, top_thickness]) 
        cube([inner_size, inner_size, height - top_thickness + 0.02]);
    
    // Remove everything above top plate except the top surface
    translate([0, 0, height]) 
        cube([outer_size, outer_size, 0.01]);
    
    // Screw holes in top plate (4 holes on 71.5mm square pattern)
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
    
    // Cable notch in one wall (front wall, centered in X, at Y = -outer_size/2)
    // Front wall is at Y = -outer_size/2
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

// Center the part properly - the part should be centered on origin
// The base should be at z=0, and the part should be centered in X and Y
translate([-outer_size/2, -outer_size/2, 0])
    stirrer_housing();