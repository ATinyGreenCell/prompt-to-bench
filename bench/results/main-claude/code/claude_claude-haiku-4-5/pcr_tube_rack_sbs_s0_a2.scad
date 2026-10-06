// PCR tube rack - 96 tubes in ANSI/SLAS footprint

// Overall dimensions
length_x = 127.76;      // mm, along X
width_y = 85.48;        // mm, along Y
height_z = 20;          // mm, height

// Hole parameters
hole_diameter = 6.2;    // mm
hole_spacing = 9.0;     // mm center-to-center
num_cols = 12;          // columns along X
num_rows = 8;           // rows along Y

// First hole position (A1)
first_hole_x = 14.38;   // mm from left edge
first_hole_y = 11.24;   // mm from back edge

// Chamfer parameters
chamfer_leg = 5;        // mm, length of chamfer leg

$fn = 64;

// Main block with holes and chamfer
difference() {
    cube([length_x, width_y, height_z], center = false);
    
    union() {
        for (col = [0 : num_cols - 1]) {
            for (row = [0 : num_rows - 1]) {
                hole_x = first_hole_x + col * hole_spacing;
                hole_y = first_hole_y + row * hole_spacing;
                translate([hole_x, hole_y, -0.5]) {
                    cylinder(h = height_z + 1, d = hole_diameter, $fn = 64);
                }
            }
        }
        translate([0, 0, height_z - chamfer_leg]) {
            linear_extrude(height = chamfer_leg + 0.5) {
                polygon([[0, 0], [chamfer_leg, 0], [0, chamfer_leg]]);
            }
        }
    }
}