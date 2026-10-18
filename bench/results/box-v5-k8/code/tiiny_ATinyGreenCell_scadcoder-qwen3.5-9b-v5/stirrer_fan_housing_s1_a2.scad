// DIY magnetic stirrer housing (print orientation: upside-down open box)
// Units: mm. Walls 2.5 mm thick. Top plate 2 mm thick.

// ---- Dimensions ----
box_outer_x   = 90;    // outer size in X
box_outer_y   = 90;    // outer size in Y
wall_thick    = 2.5;   // wall thickness
top_plate_t   = 2;     // top plate thickness (z = 0 to 2)
box_height    = 40;    // total height of box walls (z = 0 to 40)
screw_hole_d  = 4.5;   // M4 screw hole diameter
screw_pitch   = 71.5;  // square pitch of screw holes (X and Y)
notch_w       = 12;    // power cable notch width
notch_depth   = 8;     // notch depth from open edge (z = 32 to 40)
eps           = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---- Model ----
difference() {
    // Main box body: floor + four walls, open at the top
    union() {
        translate([-box_outer_x/2, -box_outer_y/2, 0])
            cube([box_outer_x, box_outer_y, box_height]);

        // Open the top: cut a block 1 mm above the top plate through the walls
        translate([-box_outer_x/2, -box_outer_y/2, box_height - top_plate_t - eps])
            cube([box_outer_x, box_outer_y, top_plate_t + 2*eps]);
    }

    // Screw holes through the top plate on a centred square pattern
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * screw_pitch/2, sy * screw_pitch/2, 0])
            cylinder(d = screw_hole_d, h = top_plate_t + eps);

    // Notch for the power cable in one wall, centred along that wall
    translate([-box_outer_x/2 + notch_w/2, -box_outer_y/2 + notch_w/2,
               box_height - notch_depth])
        cube([notch_w, box_outer_y - notch_w, notch_depth + eps]);
}