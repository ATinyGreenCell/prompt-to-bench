// Microcentrifuge tube bench rack - a rectangular block with a regular grid of vertical holes,
// for sorting or processing many tubes at once. NOVEL general part.
//

tube  = 1.5;
length  = 106;
width   = 72;
height  = 30;
grid_x  = 16;
grid_y  = 16;
holes   = 24;
d_hole  = 11.2;
depth   = 25;
floor   = 5;

$fn = 32;

difference() {
    cube([length, width, height]);
    for (i = [0 : holes - 1])
        translate([grid_x * (i % 6) - grid_x * 2.9, grid_y * floor(i / 6) - grid_y * 4.8, 0])
            cylinder(h = depth + 1, d = d_hole);
    for (z = [depth + 1 : height - 1])
        for (i = [0 : holes - 1])
            translate([grid_x * (i % 6) - grid_x * 2.9, grid_y * floor(i / 6) - grid_y * 4.8, z])
                cylinder(h = 2, d = d_hole * 0.7);   // ribbs through the holes
}