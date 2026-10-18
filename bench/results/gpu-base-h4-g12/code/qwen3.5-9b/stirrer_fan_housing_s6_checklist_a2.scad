// DIY Magnetic Stirrer Housing - built upside down on the print bed.
// Top plate (z=0 to 2) with screw holes, four walls (z=2 to 40), and a cable notch.

// Dimensions
outer_x = 90;
outer_y = 90;
top_thickness = 2;
wall_thickness = 2.5;
total_height = 40;
wall_height = total_height - top_thickness;

// Screw hole pattern
screw_hole_d = 4.5;
screw_pattern_size = 71.5;
screw_hole_z = top_thickness; // Depth of cut into the top plate

// Cable notch
notch_width = 12;
notch_depth = 8; // From open edge (z=40) down to z=32

$fn = 64;

// Main body: Top plate + 4 walls
// We build the solid block first, then subtract holes and notch.
// The block is 90x90x40.
difference() {
    // 1. The solid block
    translate([0, 0, 0]) cube([outer_x, outer_y, total_height]);

    // 2. Screw holes in the top plate
    // Pattern: 4 holes on a 71.5mm square centered on the plate.
    // Positions: +/- (71.5/2) from center.
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([
                i * (screw_pattern_size / 2),
                j * (screw_pattern_size / 2),
                0
            ]) cylinder(h = top_thickness + 1, d = screw_hole_d);
        }
    }

    // 3. Cable notch in one wall
    // The notch is in the wall at X = outer_x / 2 (right wall).
    // It is 12mm wide, centered along the wall (Y direction).
    // It reaches 8mm down from the open edge (z=40), so from z=32 to z=40.
    // We cut a rectangular prism extending slightly past the wall thickness.
    translate([
        outer_x / 2 - notch_width / 2,
        0,
        total_height - notch_depth - 0.01 // Extend slightly past the top face to ensure clean cut
    ]) cube([notch_width, outer_y + 2, notch_depth + 0.01]);
}