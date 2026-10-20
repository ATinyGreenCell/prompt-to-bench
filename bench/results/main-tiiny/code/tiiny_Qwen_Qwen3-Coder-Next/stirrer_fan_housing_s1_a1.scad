// Dimensions
outer_size = 90;          // outer X/Y size in mm
wall_thickness = 2.5;     // wall thickness in mm
top_thickness = 2;        // top plate thickness in mm
height = 40;              // total height from top plate to open top
hole_pattern_size = 71.5; // screw hole pattern square size in mm
hole_diameter = 4.5;      // screw hole diameter in mm
notch_width = 12;         // notch width in mm
notch_depth = 8;          // notch depth from top (40 - 32) in mm

// Derived dimensions
inner_size = outer_size - 2 * wall_thickness;

// Screw hole positions (4 holes on square pattern)
hole_offset = hole_pattern_size / 2;

// Notch position: centered on one wall (Y negative side)
notch_x_center = 0;
notch_y_start = -inner_size/2;
notch_y_end = notch_y_start + notch_width;
notch_z_start = height - notch_depth;

// Top plate - positioned at z = 0 to 2
module top_plate() {
    cube([outer_size, outer_size, top_thickness]);
}

// Walls - positioned on top of top plate (z = 2 to 42)
module walls() {
    // Front wall (Y negative side)
    translate([0, -inner_size/2, top_thickness])
        cube([outer_size, wall_thickness, height]);
    
    // Back wall (Y positive side)
    translate([0, inner_size/2, top_thickness])
        cube([outer_size, wall_thickness, height]);
    
    // Left wall (X negative side)
    translate([-inner_size/2, 0, top_thickness])
        cube([wall_thickness, outer_size, height]);
    
    // Right wall (X positive side)
    translate([inner_size/2, 0, top_thickness])
        cube([wall_thickness, outer_size, height]);
}

// Screw holes - through the top plate
module screw_holes() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * hole_offset, y * hole_offset, -0.01])
                cylinder(h = top_thickness + 0.02, r = hole_diameter/2, $fn = 64);
        }
    }
}

// Notch for power cable - in front wall (Y negative side)
module notch() {
    // Notch in front wall (Y negative side)
    // The notch is 12mm wide, centered on the wall, and goes 8mm down from the top (z = 42 - 8 = 34 to 42)
    translate([0, -inner_size/2, height + top_thickness - notch_depth])
        cube([notch_width + 0.1, wall_thickness + 0.1, notch_depth + 0.02]);
}

// Assemble the housing
module housing() {
    union() {
        top_plate();
        walls();
    }
}

// Subtract screw holes
module housing_with_holes() {
    difference() {
        housing();
        translate([0, 0, -0.01])
            screw_holes();
    }
}

// Subtract notch
module final_housing() {
    difference() {
        housing_with_holes();
        translate([0, 0, -0.01])
            notch();
    }
}

// Render
final_housing();