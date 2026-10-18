// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40, open top

// ---------- Parameters ----------
fan_d        = 80;    // fan diameter
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
wall         = 2.5;   // wall thickness
top_t        = 2;     // top plate thickness
open_h       = 40;    // height of open box (from top plate up)
screw_d      = 4.5;   // M4 screw hole diameter
screw_pitch  = 71.5;  // square pattern side for screw holes
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // cable notch depth from open edge
eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    // Solid block: top plate + walls
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, open_h + top_t]);

    // Screw holes through top plate
    for (sx = [-screw_pitch/2, screw_pitch/2])
        for (sy = [-screw_pitch/2, screw_pitch/2])
            translate([sx, sy, top_t])
                cylinder(d = screw_d, h = top_t + eps);

    // Cable notch in one wall (full cut through the wall)
    translate([-outer_x/2, -notch_w/2, open_h + top_t - notch_depth])
        cube([outer_x, notch_w, notch_depth + eps]);
}