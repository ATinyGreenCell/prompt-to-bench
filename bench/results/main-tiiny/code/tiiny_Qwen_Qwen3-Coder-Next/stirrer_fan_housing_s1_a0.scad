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
top_plate_size = outer_size;

// Screw hole positions (4 holes on square pattern)
hole_offset = hole_pattern_size / 2;

// Notch position: centered on one wall (Y = -inner_size/2 wall)
notch_x_center = 0;
notch_y_start = -inner_size/2;
notch_y_end = notch_y_start + notch_width;
notch_z_start = height - notch_depth;

// Top plate
module top_plate() {
    translate([0, 0, -top_thickness/2])
        cube([outer_size, outer_size, top_thickness], center=true);
}

// Walls
module walls() {
    // Front wall (Y negative side)
    translate([0, -inner_size/2, top_thickness/2])
        cube([outer_size, wall_thickness, height], center=true);
    
    // Back wall (Y positive side)
    translate([0, inner_size/2, top_thickness/2])
        cube([outer_size, wall_thickness, height], center=true);
    
    // Left wall (X negative side)
    translate([-inner_size/2, 0, top_thickness/2])
        cube([wall_thickness, outer_size, height], center=true);
    
    // Right wall (X positive side)
    translate([inner_size/2, 0, top_thickness/2])
        cube([wall_thickness, outer_size, height], center=true);
}

// Screw holes
module screw_holes() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * hole_offset, y * hole_offset, -0.01])
                cylinder(h = top_thickness + 0.02, r = hole_diameter/2, $fn = 64);
        }
    }
}

// Notch for power cable
module notch() {
    // Notch in front wall (Y negative side)
    translate([0, 0, height - notch_depth/2])
        cube([notch_width + 0.1, wall_thickness + 0.1, notch_depth + 0.02], center=true);
}

// Assemble the housing
module housing() {
    union() {
        top_plate();
        walls();
    }
    
    // Subtract screw holes
    translate([0, 0, top_thickness/2])
        difference() {
            union() {
                top_plate();
                walls();
            }
            screw_holes();
        }
    
    // Subtract notch
    translate([0, 0, top_thickness/2])
        difference() {
            union() {
                top_plate();
                walls();
            }
            translate([0, -inner_size/2 - wall_thickness/2, notch_z_start + notch_depth/2])
                cube([notch_width + 0.1, wall_thickness + 0.1, notch_depth + 0.02], center=true);
        }
}

// Render
housing();