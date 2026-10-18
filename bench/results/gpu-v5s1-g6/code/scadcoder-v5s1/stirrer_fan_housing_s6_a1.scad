// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
fan_d        = 80;    // fan diameter (mm)
outer_x      = 90;    // outer size in X (mm)
outer_y      = 90;    // outer size in Y (mm)
top_t        = 2;     // top plate thickness (mm)
wall_t       = 2.5;   // wall thickness (mm)
open_h       = 40 - top_t; // open top height from plate top (mm)
screw_d      = 4.5;   // M4 screw hole diameter (mm)
screw_n      = 4;     // number of screw holes
screw_pitch  = 71.5;  // square pattern side length (mm)
notch_w      = 12;    // cable notch width (mm)
notch_depth  = 8;     // cable notch depth from open edge (mm)
eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------- Model ----------
difference() {
    // Outer block
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, top_t + open_h]);

    // Open top (no lid)
    translate([-outer_x/2, -outer_y/2, top_t])
        cube([outer_x, outer_y, open_h + eps]);

    // Screw holes through top plate
    for (i = [0 : screw_n - 1]) {
        a = (i < 2) ? 0 : 1;   // row 0 or 1 (Y)
        b = (i < 2) ? 0 : 1;   // col 0 or 1 (X)
        translate([b ? screw_pitch/2 : -screw_pitch/2,
                   a ? screw_pitch/2 : -screw_pitch/2,
                   eps])
            cylinder(d = screw_d, h = top_t + 1);
    }

    // Cable notch in one wall (centred along wall, z = 32..40)
    translate([-outer_x/2, -notch_w/2, top_t + open_h - notch_depth])
        cube([outer_x, notch_w, notch_depth + eps]);
}