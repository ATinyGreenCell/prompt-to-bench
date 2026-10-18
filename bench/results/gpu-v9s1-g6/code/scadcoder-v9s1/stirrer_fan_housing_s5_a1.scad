// Magnetic stirrer housing - upside-down open box over PC fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height (open top at z = 40)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
screw_d      = 4.5;   // M4 screw hole diameter
screw_n      = 4;     // number of screw holes
screw_pitch  = 71.5;  // square pattern side length (hole centre to hole centre)
notch_w      = 12;    // cable notch width
notch_d      = 8;     // cable notch depth from open edge
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Closed top plate
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, plate_t]);

    // Four walls, open top, with overshoot above the open edge
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([outer_x/2 - eps, -outer_y/2, plate_t])
                cube([eps, outer_y, box_h + eps]);

    // Screw holes through the top plate, centred on the plate
    for (i = [0 : screw_n - 1]) {
        for (j = [0 : screw_n - 1]) {
            x = (i - (screw_n - 1)/2) * screw_pitch;
            y = (j - (screw_n - 1)/2) * screw_pitch;
            translate([x, y, -eps])
                cylinder(d = screw_d, h = plate_t + 2*eps);
        }
    }

    // Cable notch in one wall: 12 mm wide, centred along the wall,
    // reaching 8 mm down from the open edge (z = 32 to z = 40)
    translate([outer_x/2 - notch_w/2, 0, plate_t + notch_d])
        cube([notch_w, outer_y, notch_w]);
}