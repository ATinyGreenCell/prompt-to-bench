// Magnetic stirrer housing - open box covering an 80 mm PC fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40

// ---- Dimensions (mm) ----
top_t        = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height of walls
outer        = 90;    // outer size (X x Y)
hole         = 4.5;   // M4 screw hole diameter
hole_pitch   = 71.5;  // square pattern of screw holes
notch_w      = 12;    // cable notch width
notch_bottom = 8;     // notch depth from open edge
eps          = 0.5;   // cutter overshoot

$fn = 64;

difference() {
    // Solid box
    translate([-outer/2, -outer/2, 0])
        cube([outer, outer, top_t + wall_t]);

    // Open top: hollow to z = 32, leaving the lower walls solid
    translate([-outer/2, -outer/2, top_t])
        cube([outer, outer, wall_t + 8 - eps]);

    // Screw holes through the top plate
    for (sx = [-hole_pitch/2, hole_pitch/2])
        for (sy = [-hole_pitch/2, hole_pitch/2])
            translate([sx, sy, -eps])
                cylinder(d = hole, h = top_t + 2*eps);

    // Cable notch in one wall, centred along the wall
    translate([-outer/2 - wall_t/2, 0, top_t + wall_t - notch_bottom])
        cube([notch_w, outer, notch_bottom + eps]);
}