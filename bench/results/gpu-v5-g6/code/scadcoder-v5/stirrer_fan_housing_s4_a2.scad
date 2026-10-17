// DIY magnetic stirrer housing - print orientation (upside down)
// Units: mm. Walls 2.5 mm thick. Top plate 2 mm thick.

$fn = 64;

// --- Dimensions ---
fan_d          = 80;    // fan diameter
outer_x        = 90;    // outer size in X
outer_y        = 90;    // outer size in Y
wall           = 2.5;   // wall thickness
top_plate      = 2;     // top plate thickness
box_height     = 40;    // total height of box (open at top)
screw_hole     = 4.5;   // M4 screw hole diameter
screw_pattern  = 71.5;  // square pitch of screw holes
notch_w        = 12;    // cable notch width
notch_depth    = 8;     // notch depth from open edge
eps            = 0.5;   // cutter overshoot

// --- Model ---
difference() {
    union() {
        // Top plate on bed
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, top_plate]);

        // Four walls rising to box_height
        for (dx = [-outer_x/2 - wall, outer_x/2])
            for (dy = [-outer_y/2 - wall, outer_y/2])
                translate([dx, dy, 0])
                    cube([wall, wall, box_height]);
    }

    // Four M4 screw holes through top plate, centred
    for (sx = [-screw_pattern/2, screw_pattern/2],
         sy = [-screw_pattern/2, screw_pattern/2])
        translate([sx, sy, -eps])
            cylinder(d = screw_hole, h = top_plate + 2*eps);

    // Cable notch in one wall, centred along the wall
    translate([-outer_x/2 - wall, 0, box_height - notch_depth])
        cube([wall, notch_w, notch_depth + eps]);
}