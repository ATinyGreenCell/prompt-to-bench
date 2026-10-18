// Magnetic stirrer housing - open box covering an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0 to 2), walls rise to z = 40

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;    // wall thickness
outer_x      = 90;     // outer size in X
outer_y      = 90;     // outer size in Y
open_top_z   = 40;     // height of open top
notch_w      = 12;     // cable notch width
notch_bottom = 8;      // notch starts here (bottom of notch)
notch_top    = open_top_z; // notch reaches the open edge
screw       = 4.5;     // M4 screw hole diameter
screw_pitch = 71.5;    // square diagonal between screw centres
eps          = 0.5;    // cutter overshoot

$fn = 64;

difference() {
    // Solid block
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, open_top_z + wall_t]);

    // Open top (hollow above z = open_top_z)
    translate([-outer_x/2, -outer_y/2, open_top_z])
        cube([outer_x, outer_y, wall_t + eps]);

    // Screw holes in top plate
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([0, 0, -eps])
                cylinder(d = screw, h = plate_t + 2*eps);
    }

    // Cable notch in one wall
    translate([-notch_w/2, -wall_t/2, notch_bottom])
        cube([notch_w, wall_t + eps, notch_top - notch_bottom + eps]);
}