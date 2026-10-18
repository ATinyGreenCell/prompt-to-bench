// Magnetic stirrer housing - upside-down open box over PC fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height from plate top to open top
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_n       = 4;     // number of screw holes
hole_pitch   = 71.5;  // square hole pattern side length
notch_w      = 12;    // cable notch width
notch_d      = 8;     // cable notch depth from open edge
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---- Model ----
difference() {
    // Closed top plate, open box below (overlapping slightly at seam)
    union() {
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);
        translate([-outer_x/2, -outer_y/2, plate_t - eps])
            cube([outer_x, outer_y, box_h + eps]);
    }

    // Screw holes through top plate, centred on plate
    for (i = [0 : hole_n - 1])
        for (j = [0 : hole_n - 1]) {
            x = (i - (hole_n - 1)/2) * hole_pitch;
            y = (j - (hole_n - 1)/2) * hole_pitch;
            translate([x, y, -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
        }

    // Cable notch in one wall, centred along wall, open at top
    translate([-outer_x/2, -outer_y/2, plate_t])
        difference() {
            cube([outer_x, outer_y, box_h]);
            translate([0, -outer_y/2 - eps, box_h - notch_d])
                cube([notch_w, outer_y + 2*eps, notch_d]);
        }
}