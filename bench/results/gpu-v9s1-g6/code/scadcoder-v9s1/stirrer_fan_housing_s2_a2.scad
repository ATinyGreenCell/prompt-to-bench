// Magnetic stirrer housing - upside-down open box over a 80 mm PC fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height of box (open top)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
screw_d      = 4.5;   // M4 screw hole diameter
screw_pitch  = 71.5;  // square pattern pitch for screw holes
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // cable notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Closed top plate
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, plate_t]);

    // Four walls, open top, with screw holes through the top plate
    for (i = [0 : 3]) {
        rotate([0, 0, i * 90])
            translate([0, 0, plate_t])
                cube([outer_x, wall_t, box_h - plate_t]);
    }

    // Screw holes, centred on the plate
    for (j = [0 : 3]) {
        for (k = [0 : 3]) {
            x = (j - 1) * screw_pitch;
            y = (k - 1) * screw_pitch;
            translate([x, y, -eps])
                cylinder(d = screw_d, h = plate_t + 2 * eps);
        }
    }

    // Cable notch in one wall, centred along the wall
    translate([-outer_x/2 + notch_w/2, -wall_t/2, box_h - notch_depth])
        cube([notch_w, wall_t, notch_depth]);
}