// Magnetic stirrer housing - upside-down open box over 80 mm PC fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height of box (open top at z = 40)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
screw_d      = 4.5;   // M4 screw hole diameter
screw_count  = 4;     // number of screw holes
screw_pitch  = 71.5;  // square pattern side-to-side hole spacing
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // cable notch depth from open edge (z = 32 to z = 40)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Outer block
    translate([-outer_x / 2, -outer_y / 2, 0])
        cube([outer_x, outer_y, box_h]);

    // Screw holes through top plate, centred on plate
    for (i = [0 : screw_count - 1]) {
        for (j = [0 : screw_count - 1]) {
            x = (i - (screw_count - 1) / 2) * screw_pitch;
            y = (j - (screw_count - 1) / 2) * screw_pitch;
            translate([x, y, -eps])
                cylinder(d = screw_d, h = plate_t + 2 * eps);
        }
    }

    // Cable notch in one wall, centred along wall, from z = 32 to z = 40
    translate([-outer_x / 2 + screw_pitch / 2, -outer_y / 2, box_h - notch_depth])
        cube([notch_w, outer_y, notch_depth + eps]);

    // Floor under notch to avoid coincident faces
    translate([-outer_x / 2, -outer_y / 2, box_h - notch_depth - eps])
        cube([outer_x, outer_y, eps]);
}