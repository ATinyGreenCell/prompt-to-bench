// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

// ---------- Dimensions ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // outer wall height (open top)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_pitch   = 71.5;  // square pattern centre-to-centre
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Four walls rising to z = box_h
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_x/2 - wall_t : -outer_x/2,
                       sy > 0 ? outer_y/2 - wall_t : -outer_y/2,
                       0])
                cube([wall_t, outer_y - 2*wall_t, box_h]);
    }

    // Screw holes through top plate on 71.5 mm square pattern
    for (i = [0 : 3]) {
        a = (i % 2) * hole_pitch;
        b = (i / 2) * hole_pitch;
        translate([a - outer_x/2, b - outer_y/2, -eps])
            cylinder(d = hole_d, h = plate_t + 2*eps);
    }

    // Cable notch in one wall (z = 32 to 40, open edge down)
    translate([-outer_x/2, -outer_y/2/2 + notch_w/2, box_h - notch_depth])
        cube([outer_x, notch_w, notch_depth + eps]);
}