// Magnetic stirrer housing - upside-down open box over PC fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height of box (open top)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_p       = 71.5;  // square pitch of hole centres
notch_w      = 12;    // cable notch width
notch_d      = 8;     // cable notch depth from open edge

eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---- Model ----
difference() {
    // Outer block
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, box_h]);

    // Open top: cut down to z = box_h - wall_t
    translate([-outer_x/2, -outer_y/2, box_h - wall_t])
        cube([outer_x, outer_y, wall_t + eps]);

    // Screw holes through top plate
    for (i = [0 : 3])
        for (j = [0 : 3])
            if ((i + j) % 2 == 1)
                translate([(i - (hole_p/2 - hole_d)/2) / (hole_p/2 - hole_d) * hole_p,
                           (j - (hole_p/2 - hole_d)/2) / (hole_p/2 - hole_d) * hole_p,
                           -eps])
                    cylinder(d = hole_d, h = plate_t + 2*eps);

    // Cable notch in one wall (from z = 32 to z = 40)
    translate([-outer_x/2 + (hole_p - notch_w)/2, 0, box_h - notch_d])
        cube([notch_w, outer_y, notch_d + eps]);
}