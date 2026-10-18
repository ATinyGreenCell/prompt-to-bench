// Magnetic stirrer housing - upside-down open box over a 80 mm PC fan
// Print orientation: top plate on bed (z = 0..2), walls rise to z = 40

// ---------- Parameters ----------
box_outer_x      = 90;    // outer size in X (mm)
box_outer_y      = 90;    // outer size in Y (mm)
top_plate_t      = 2;     // top plate thickness (mm)
wall_t           = 2.5;   // wall thickness (mm)
wall_top_z       = 40;    // height of open top (mm)
screw_hole_d     = 4.5;   // M4 screw hole diameter (mm)
screw_pattern_a  = 71.5;  // square pitch of screw holes (mm)
notch_w          = 12;    // cable notch width (mm)
notch_bottom_z   = 32;    // notch floor height (mm)
eps              = 0.5;   // cutter overshoot past faces (mm)
$fn              = 64;    // curve resolution

// ---------- Model ----------
difference() {
    // Solid body: top plate + four walls, open top
    union() {
        // Top plate
        translate([-box_outer_x/2, -box_outer_y/2, 0])
            cube([box_outer_x, box_outer_y, top_plate_t]);
        // Walls
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? box_outer_x/2 - wall_t : -box_outer_x/2,
                       sy > 0 ? box_outer_y/2 - wall_t : -box_outer_y/2,
                       0])
                cube([wall_t, box_outer_y - 2*wall_t, wall_top_z]);
    }

    // Screw holes through top plate, centred on plate
    for (i = [0, 1, 2, 3])
        translate([(i < 2 ? -1 : 1) * screw_pattern_a/2,
                   (i % 2 ? -1 : 1) * screw_pattern_a/2,
                   top_plate_t/2])
            cylinder(d = screw_hole_d, h = top_plate_t + eps);

    // Cable notch in one wall: 12 mm wide, centred along wall,
    // from z = 32 up to above the open edge (eps past z = 40)
    translate([-box_outer_x/2 + wall_t + eps,
               -box_outer_y/2 + wall_t,
               notch_bottom_z])
        cube([notch_w, box_outer_y - 2*wall_t, wall_top_z - notch_bottom_z + eps]);
}