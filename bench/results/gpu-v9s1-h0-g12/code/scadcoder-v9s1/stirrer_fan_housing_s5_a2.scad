// Magnetic stirrer housing - upside-down open box over PC fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40

$fn = 64;

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height (open top at z = 40)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_n       = 4;     // number of screw holes
hole_pitch   = 71.5;  // square hole pattern side length
notch_w      = 12;    // cable notch width
notch_d      = 8;     // notch depth from open edge
eps          = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    // Closed top plate, open box below
    union() {
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);
        translate([-outer_x/2, -outer_y/2, plate_t])
            cube([outer_x, outer_y, box_h - plate_t]);
    }

    // Screw holes through top plate, centred on plate
    for (i = [0 : hole_n - 1]) {
        a = (i < 2) ? 0 : 90;   // two rows along Y
        translate([hole_pitch/2 - hole_pitch/2, a ? hole_pitch/2 : -hole_pitch/2, plate_t/2 - eps])
            rotate([0, 0, a])
                cylinder(d = hole_d, h = plate_t + 2*eps);
    }

    // Cable notch in one wall, centred along the wall
    translate([-outer_x/2 + notch_w/2, -outer_y/2, box_h - notch_d])
        cube([notch_w, outer_y, notch_d + eps]);
}