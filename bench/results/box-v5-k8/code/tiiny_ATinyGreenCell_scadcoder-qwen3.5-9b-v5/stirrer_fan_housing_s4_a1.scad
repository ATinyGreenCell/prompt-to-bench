// DIY magnetic stirrer housing for an 80 mm PC case fan
// Print orientation: upside-down open box, top plate on the bed

// ---- Dimensions (mm) ----
box_outer_x   = 90;    // outer size in X
box_outer_y   = 90;    // outer size in Y
top_plate_t   = 2;     // top plate thickness (z = 0 to 2)
wall_t        = 2.5;   // wall thickness (z = 2 to 40)
open_top_z    = 40;    // open top of box
screw_hole_d  = 4.5;   // M4 screw holes
screw_pitch   = 71.5;  // square pattern diagonal
notch_w       = 12;    // power cable notch width
notch_depth   = 8;     // notch depth from open edge (z = 32 to 40)
eps           = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---- Model ----
difference() {
    // Solid box: top plate + four walls, open at the top
    translate([-box_outer_x/2, -box_outer_y/2, 0])
        cube([box_outer_x, box_outer_y, open_top_z]);

    // Four through-cut walls, leaving the top open
    for (dx = [-box_outer_x/2 + wall_t, box_outer_x/2 - wall_t],
         dy = [-box_outer_y/2 + wall_t, box_outer_y/2 - wall_t])
        translate([dx, dy, 0])
            cube([wall_t, wall_t, open_top_z + eps]);

    // Four M4 screw holes in the top plate on a 71.5 mm square pattern
    for (x = [-screw_pitch/2, screw_pitch/2], y = [-screw_pitch/2, screw_pitch/2])
        translate([x, y, -eps])
            cylinder(d = screw_hole_d, h = top_plate_t + 2*eps);

    // Notch in one wall for the power cable, centred along the wall
    translate([-box_outer_x/2 + wall_t, -box_outer_y/2 + wall_t, open_top_z - notch_depth])
        cube([notch_w, box_outer_y - 2*(box_outer_y/2 - wall_t), notch_depth + eps]);
}