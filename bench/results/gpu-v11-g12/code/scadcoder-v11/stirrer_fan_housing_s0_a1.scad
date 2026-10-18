// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)
// Note: this is the "upside-down" open-box orientation specified

// ---------- Dimensions (mm) ----------
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
plate_t      = 2;     // top plate thickness (z = 0 to 2)
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // outer wall height (top edge at z = 40)
hole_d       = 4.5;   // M4 screw hole diameter
hole_pitch   = 71.5;  // square pattern centre-to-centre distance
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // cable notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;             // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Four walls rising from the top edge of the plate
        for (x = [-1, 1], y = [-1, 1])
            translate([x > 0 ? outer_x/2 - wall_t : -outer_x/2,
                       y > 0 ? outer_y/2 - wall_t : -outer_y/2,
                       plate_t - 0.01])
                cube([wall_t, outer_y - 2*wall_t, box_h - plate_t + 0.01]);
    }

    // Screw holes through the top plate on a 71.5 mm square pattern
    for (s = [-1, 1])
        for (t = [-1, 1])
            translate([s * hole_pitch/2, t * hole_pitch/2, -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);

    // Cable notch cut into one wall, reaching down from the open edge
    translate([-outer_x/2, -notch_w/2, box_h - notch_depth])
        cube([notch_w, outer_y, notch_depth + eps]);
}