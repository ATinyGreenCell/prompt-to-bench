// DIY Magnetic Stirrer Housing - corrected geometry.
// Orientation: Top plate on bed (z=0), walls rising to z=40.
// Outer size: 90x90mm. Fan size: 80x80mm.

// Dimensions
outer_size = 90;
fan_size   = 80;
wall_thickness = 2.5;
top_thickness = 2;
wall_height  = 40;

// Hole dimensions
screw_hole_d = 4.5;
screw_hole_pattern = 71.5;

// Notch dimensions
notch_width = 12;
notch_depth = 8; // reaches from z=32 to z=40

$fn = 64;

// Calculate positions
// The part sits on the bed.
// Top plate is 90x90, centred on origin, sitting on z=0.
// Walls rise from the perimeter of the top plate.
// The inner void is 80x80.

module main_body() {
    // Create the solid block: Top plate + Walls
    // Outer dimensions of the solid block (including walls) must be 90mm x 90mm.
    // The walls sit on top of the plate.
    // Plate is 90x90. Walls are 2.5mm thick.
    // So the total width/depth is 90 + 2.5 + 2.5 = 95mm.
    // Height is top_thickness + wall_height = 2 + 40 = 42mm.
    
    outer_w = outer_size + 2 * wall_thickness;
    outer_h = outer_size + 2 * wall_thickness;
    total_h = top_thickness + wall_height;
    
    // Inner void dimensions (the space for the fan)
    // The void starts at z = top_thickness.
    // The void width/depth is fan_size.
    inner_w = fan_size;
    inner_h = fan_size;
    void_z_start = top_thickness;
    void_z_end = total_h;
    
    difference() {
        // 1. The main solid block
        // Centered at origin.
        translate([0, 0, 0]) 
            cube([outer_w, outer_h, total_h]);
        
        // 2. The inner void (open box)
        // This void is a rectangular prism starting at z = top_thickness.
        // It is centered on the origin.
        translate([0, 0, void_z_start]) 
            cube([inner_w, inner_h, void_z_end - void_z_start]);
    }
}

module screw_holes() {
    // Four holes on a 71.5mm square pattern centred on the plate.
    // The plate is 90x90. The pattern is centred.
    // Distance from centre to hole centre is 71.5 / 2 = 35.75.
    
    offset = screw_hole_pattern / 2;
    
    for (i = [0 : 3]) {
        // Determine X and Y offsets based on index
        // 0: -X, -Y
        // 1: +X, -Y
        // 2: +X, +Y
        // 3: -X, +Y
        if (i == 0) {
            translate([-offset, -offset, 0]) 
                cylinder(h = top_thickness + 1, d = screw_hole_d);
        } else if (i == 1) {
            translate([offset, -offset, 0]) 
                cylinder(h = top_thickness + 1, d = screw_hole_d);
        } else if (i == 2) {
            translate([offset, offset, 0]) 
                cylinder(h = top_thickness + 1, d = screw_hole_d);
        } else {
            translate([-offset, offset, 0]) 
                cylinder(h = top_thickness + 1, d = screw_hole_d);
        }
    }
}

module cable_notch() {
    // Notch in one wall.
    // 12mm wide, centred along the wall.
    // Reaches 8mm down from the open edge (z=32 to z=40).
    // Let's place it on the +Y wall (right side when looking from top).
    // The wall is at x = outer_size/2 = 45.
    // The notch goes from x = 45 - notch_width/2 to x = 45 + notch_width/2.
    // It goes from z = 32 to z = 40.
    
    wall_x = outer_size / 2;
    notch_x_start = wall_x - notch_width / 2;
    notch_x_end = wall_x + notch_width / 2;
    
    // Cut the notch
    translate([notch_x_start, 0, 32]) 
        cube([notch_width, outer_size + 2 * wall_thickness, notch_depth]);
}

// Main assembly
difference() {
    union() {
        main_body();
        screw_holes();
        cable_notch();
    }
}