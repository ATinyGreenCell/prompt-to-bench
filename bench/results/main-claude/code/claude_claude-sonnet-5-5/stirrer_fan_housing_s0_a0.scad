// DIY magnetic stirrer housing (print orientation: upside down)
$fn = 64;

box_x = 90;          // outer size X
box_y = 90;          // outer size Y
box_h = 40;          // total height
top_t = 2;           // top plate thickness
wall_t = 2.5;        // wall thickness
hole_d = 4.5;        // M4 screw hole diameter
hole_pitch = 71.5;   // square hole pattern spacing
notch_w = 12;        // cable notch width
notch_h = 8;         // cable notch depth from open edge

difference() {
    union() {
        // top plate
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, top_t]);
        // walls
        difference() {
            translate([-box_x/2, -box_y/2, 0])
                cube([box_x, box_y, box_h]);
            translate([-box_x/2 + wall_t, -box_y/2 + wall_t, top_t])
                cube([box_x - 2*wall_t, box_y - 2*wall_t, box_h]);
        }
    }

    // fan mounting holes
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*hole_pitch/2, sy*hole_pitch/2, -1])
            cylinder(d = hole_d, h = top_t + 2);

    // cable notch in the +Y wall
    translate([-notch_w/2, box_y/2 - wall_t - 1, box_h - notch_h])
        cube([notch_w, wall_t + 2, notch_h + 1]);
}