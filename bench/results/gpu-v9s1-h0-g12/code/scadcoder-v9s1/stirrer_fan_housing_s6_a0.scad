// DIY magnetic stirrer housing - upside-down open box over PC fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height (open top at z = 40)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
screw_d      = 4.5;   // M4 screw hole diameter
screw_n      = 4;     // number of screw holes
screw_pitch  = 71.5;  // square pattern pitch (centre to centre)
notch_w      = 12;    // cable notch width
notch_d      = 8;     // cable notch depth from open edge
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Outer block
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, box_h]);

    // Open top: cut down to z = box_h - wall_t, leaving a rim
    translate([-outer_x/2 - eps, -outer_y/2 - eps, box_h - wall_t])
        cube([outer_x + 2*eps, outer_y + 2*eps, wall_t + eps]);

    // Screw holes through top plate, centred on plate
    for (i = [0 : screw_n - 1]) {
        a = (i < 2) ? 0 : 90;   // two rows along Y
        translate([screw_pitch/2, a ? screw_pitch/2 : -screw_pitch/2, plate_t])
            cylinder(d = screw_d, h = plate_t + eps, $fn = 64);
    }

    // Cable notch in one wall, centred along the wall
    translate([-outer_x/2 + notch_w/2, -outer_y/2 - eps, box_h - notch_d])
        cube([notch_w, outer_y + 2*eps, notch_d + eps]);
}