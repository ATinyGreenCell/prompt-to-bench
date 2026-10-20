// Dimensions for DIY Magnetic Stirrer Housing (80mm PC Fan)
// Units: millimetres

// Overall outer footprint
outer_width = 90;
outer_depth = 90;

// Top plate thickness (rests on bed)
top_thickness = 2;

// Wall thickness
wall_thickness = 2.5;

// Total height of the box (from top plate to open edge)
box_height = 40;

// Screw hole diameter
screw_hole_dia = 4.5;

// Screw hole pattern size (square)
screw_pattern = 71.5;

// Cable notch width
notch_width = 12;

// Cable notch depth from open edge
notch_depth = 8;

// Calculate inner dimensions
inner_width = outer_width - 2 * wall_thickness;
inner_depth = outer_depth - 2 * wall_thickness;

// Calculate wall height (from top of plate to open edge)
wall_height = box_height - top_thickness;

// Calculate screw hole positions (centered on 71.5mm square)
screw_offset = screw_pattern / 2;

// Calculate notch position (centered on one wall, e.g., front wall at Y = -inner_depth/2)
// The notch is on the wall at Y = -inner_depth/2 (front face)
notch_y_center = -inner_depth / 2;
notch_z_start = box_height - notch_depth; // 40 - 8 = 32
notch_z_end = box_height; // 40

// Main body: Top plate
module top_plate() {
    cube([outer_width, outer_depth, top_thickness], center = true);
}

// Main body: Four walls
module walls() {
    // Front wall (Y = -inner_depth/2)
    // Centered at Y = -inner_depth/2, X = 0
    translate([0, -inner_depth/2, top_thickness])
        cube([outer_width, wall_thickness, wall_height], center = false);
    
    // Back wall (Y = inner_depth/2)
    translate([0, inner_depth/2, top_thickness])
        cube([outer_width, wall_thickness, wall_height], center = false);
    
    // Left wall (X = -inner_width/2)
    translate([-inner_width/2, 0, top_thickness])
        cube([wall_thickness, inner_depth, wall_height], center = false);
    
    // Right wall (X = inner_width/2)
    translate([inner_width/2, 0, top_thickness])
        cube([wall_thickness, inner_depth, wall_height], center = false);
}

// Cable notch cutout
module cable_notch() {
    // Notch is on the front wall (Y = -inner_depth/2)
    // We cut a rectangular prism from the front face
    // The notch goes from z=32 to z=40 (depth 8)
    // It is centered on the wall (Y = -inner_depth/2)
    // The wall thickness is 2.5, so we cut through it.
    // We need to ensure the cut extends slightly past the face to avoid coplanar issues.
    translate([0, -inner_depth/2 - wall_thickness/2, notch_z_start])
        cube([notch_width, wall_thickness + 0.01, notch_depth], center = false);
}

// Screw holes
module screw_holes() {
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([i * screw_offset, j * screw_offset, 0])
                cylinder(d = screw_hole_dia, h = box_height + 0.01, center = true);
        }
    }
}

// Main assembly
union() {
    // Base plate
    top_plate();
    
    // Walls
    walls();
    
    // Cable notch (difference from walls)
    difference() {
        walls();
        cable_notch();
    }
    
    // Screw holes (difference from plate and walls)
    difference() {
        union() {
            top_plate();
            walls();
        }
        screw_holes();
    }
}