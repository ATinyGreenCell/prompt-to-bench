$fn = 64;

block_length = 106; // mm
block_width = 72;   // mm
block_height = 30;  // mm
hole_diameter = 11.2; // mm
hole_depth = 25;    // mm
spacing_x = 16;     // mm
spacing_y = 16;    // mm

difference() {
    cube([block_length, block_width, block_height], center=false);
    for (i = [0:5]) {
        x = (block_length - (5 * spacing_x)) / 2 + i * spacing_x;
        for (j = [0:3]) {
            y = (block_width - (3 * spacing_y)) / 2 + j * spacing_y;
            translate([x, y, 0]) 
                cylinder(r = hole_diameter / 2, h = hole_depth, $fn=64);
        }
    }
}