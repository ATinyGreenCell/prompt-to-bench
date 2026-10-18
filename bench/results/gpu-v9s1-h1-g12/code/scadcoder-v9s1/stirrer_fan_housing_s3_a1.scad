// Magnetic stirrer housing - upside-down open box over PC fan
// Print orientation: top plate flat on bed, walls rising in +Z

$fn = 64;

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height (plate + walls)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_p       = 71.5;  // square pitch of screw holes
notch_w      = 12;    // cable notch width
notch_bottom = 32;    // notch floor height (z)
eps          = 0.5;   // cutter overshoot

// ---- Model ----
difference() {
    // Box body
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);
        // Walls
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([-outer_x/2, -outer_y/2, plate_t])
                    cube([outer_x, wall_t, box_h - plate_t]);
    }

    // Screw holes through top plate
    for (i = [0 : 3])
        for (j = [0 : 3])
            if (i + j == 3 || (i % 2 == 0 && j % 2 == 0))
                translate([(i - (hole_p - hole_d)/2) / 2,
                           (j - (hole_p - hole_d)/2) / 2,
                           -eps])
                    cylinder(d = hole_d, h = plate_t + 2*eps);

    // Cable notch in one wall, open at the top edge
    translate([-outer_x/2 - eps, -outer_y/2 - eps, notch_bottom])
        cube([outer_x + 2*eps, notch_w, box_h - notch_bottom]);
}