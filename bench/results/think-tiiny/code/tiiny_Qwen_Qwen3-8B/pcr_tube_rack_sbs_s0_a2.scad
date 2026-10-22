$fn = 64;

// Dimensions
block_length = 127.76;
block_width = 85.48;
block_height = 20;
hole_diameter = 6.2;
hole_radius = hole_diameter / 2;
spacing = 9.0;
first_hole_x = 14.38;
first_hole_y = 11.24;
chamfer_length = 5;

// Main block
difference() {
    cube([block_length, block_width, block_height]);
    // Chamfer
    translate([-block_length/2, -block_width/2, 0]) {
        rotate([0, 0, 45]) {
            cube([chamfer_length, chamfer_length, chamfer_length], center=false);
        }
    }
    // Holes
    for (i = [0:11]) {
        for (j = [0:7]) {
            x = -block_length/2 + first_hole_x + i * spacing;
            y = -block_width/2 + first_hole_y + j * spacing;
            translate([x, y, 0]) {
                cylinder(r=hole_radius, h=block_height, $fn=64);
            }
        }
    }
}