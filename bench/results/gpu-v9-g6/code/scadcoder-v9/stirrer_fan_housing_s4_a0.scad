// Magnetic stirrer housing - open box covering an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
outer_x      = 90;    // outer size in X (mm)
outer_y      = 90;    // outer size in Y (mm)
plate_t      = 2;     // top plate thickness (mm), z = 0..2
wall_t       = 2.5;   // wall thickness (mm), z = 2..40
open_top_z   = 40;    // height of open top (mm)
screw_holes  = 4;     // number of M4 screw holes
screw_d      = 4.5;   // screw hole diameter (mm)
screw_pitch  = 71.5;  // square pattern size between holes (mm)
notch_w      = 12;    // cable notch width (mm)
notch_bottom = 8;     // notch depth from open edge (mm), z = 32..40

eps          = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Four walls, open top
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_x/2 - wall_t : -outer_x/2,
                       sy > 0 ? outer_y/2 - wall_t : -outer_y/2,
                       plate_t])
                cube([wall_t, outer_y - 2*wall_t, open_top_z - plate_t]);
    }

    // Screw holes through top plate
    for (i = [0 : screw_holes - 1]) {
        a = screw_pitch / 2;
        x = (i % 2) * a - a / 2;
        y = (i / 2) * a - a / 2;
        translate([x, y, -eps])
            cylinder(d = screw_d, h = plate_t + 2 * eps);
    }

    // Cable notch in one wall (along +X wall, centred in Y)
    translate([outer_x/2 - wall_t, -notch_w/2, open_top_z - notch_bottom])
        cube([wall_t + eps, notch_w, notch_bottom + eps]);
}