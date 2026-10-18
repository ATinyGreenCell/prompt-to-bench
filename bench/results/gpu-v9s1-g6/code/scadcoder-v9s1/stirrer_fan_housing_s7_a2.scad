// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: upside down - top plate on bed, open bottom at fan

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // wall height (z = 2 to 42)
outer_x      = 90;    // outer size X
outer_y      = 90;    // outer size Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_pitch   = 71.5;  // square hole pattern side
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // cable notch depth from open edge
eps          = 0.5;   // cutter overshoot

$fn = 64;

// ---- Model ----
difference() {
    // Closed top plate (z = 0 to 2)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, plate_t]);

    // Four walls rising from plate to open top (z = 2 to 42)
    for (dx = [-1, 1], dy = [-1, 1])
        translate([dx > 0 ? outer_x/2 - wall_t : -outer_x/2,
                   dy > 0 ? outer_y/2 - wall_t : -outer_y/2,
                   plate_t])
            cube([wall_t, wall_t, box_h]);

    // Screw holes through top plate, centred square pattern
    for (i = [0 : 1], j = [0 : 1])
        translate([(i - 0.5) * hole_pitch, (j - 0.5) * hole_pitch, -eps])
            cylinder(d = hole_d, h = plate_t + 2*eps);

    // Cable notch in one wall (reaches from open edge down to z = 32)
    translate([outer_x/2 - wall_t, -notch_w/2, plate_t + box_h - notch_depth])
        cube([wall_t, notch_w, notch_depth]);
}