// Magnetic stirrer housing - open box covering an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
outer_x      = 90;    // outer size in X (mm)
outer_y      = 90;    // outer size in Y (mm)
plate_t      = 2;     // top plate thickness (mm)
wall_t       = 2.5;   // wall thickness (mm)
open_top_z   = 40;    // height of open top / wall tops (mm)
screw_holes  = 4;     // number of M4 screw holes
screw_d      = 4.5;   // screw hole diameter (mm)
screw_pitch  = 71.5;  // square pattern size for screw holes (mm)
notch_w      = 12;    // power cable notch width (mm)
notch_bottom = 8;     // notch depth from open edge (mm), z = 32..40

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------- Model ----------
difference() {
    // Solid block: top plate + four walls
    union() {
        // Top plate (lies on bed in print orientation)
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Inner hollow, open at the top (from z = plate_t up to open_top_z)
        translate([-outer_x/2, -outer_y/2, plate_t])
            cube([outer_x, outer_y, open_top_z - plate_t + 0.01]);
    }

    // Screw holes through the top plate, centred on the plate
    for (i = [0 : screw_holes - 1]) {
        rotate([0, 0, i * 360 / screw_holes])
            translate([0, 0, -eps])
                cylinder(d = screw_d, h = plate_t + 2 * eps);
    }

    // Cable notch in one wall: centred along the wall, z = 32..40
    translate([-outer_x/2 + (outer_x - notch_w)/2, 0, notch_bottom])
        cube([notch_w, outer_y, notch_w]);  // square notch, w x h = 12 x 12
}