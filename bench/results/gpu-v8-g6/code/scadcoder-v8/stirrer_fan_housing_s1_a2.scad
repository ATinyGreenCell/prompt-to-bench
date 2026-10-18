// Magnetic stirrer housing - upside-down open box over a 80 mm PC fan
// Print orientation: top plate on bed (z = 0..2), walls rise to z = 40

$fn = 64;

// ---- Dimensions (mm) ----
top_t      = 2;     // top plate thickness
wall_t     = 2.5;   // wall thickness
box_h      = 40;    // outer height (z of open top)
outer_w    = 90;    // outer size in X and Y
hole_d     = 4.5;   // M4 screw hole diameter
hole_p     = 71.5;  // square pitch of screw holes
notch_w    = 12;    // cable notch width
notch_bot  = 8;     // notch depth from open edge (z = 32..40)
eps        = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    // Outer box
    hull() {
        cube([outer_w, outer_w, top_t]);                          // bottom plate (z=0..2)
        cube([outer_w - 2*wall_t, outer_w - 2*wall_t, box_h]);   // inner block (z=2..40)
    }

    // Four screw holes through the top plate, centred on the plate
    for (i = [0 : 3])
        translate([-hole_p/2, -hole_p/2, top_t])
            cylinder(d = hole_d, h = top_t + eps, $fn = 64);

    // Cable notch in one wall, centred along the wall, open edge at z = box_h
    translate([-notch_w/2, -outer_w/2 + wall_t, box_h - notch_bot])
        cube([notch_w, outer_w/2 - wall_t, notch_bot + eps]);
}