// DIY magnetic stirrer housing - upside-down open box over 80 mm PC fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

$fn = 64;

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height (open top at z = 40)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
screw_d      = 4.5;   // M4 screw hole diameter
screw_pitch  = 71.5;  // square pattern diagonal (hole centre to hole centre)
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // notch depth from open edge (z = 32 to z = 40)
eps          = 0.5;   // cutter overshoot past faces

// ---- Derived ----
screw_h = box_h;      // holes go through full height
notch_x = 0;          // centred along X axis of wall

difference() {
    // Main body: top plate + four walls
    union() {
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_x/2 - wall_t : -outer_x/2,
                       sy > 0 ? outer_y/2 - wall_t : -outer_y/2,
                       plate_t])
                cube([wall_t, outer_y - 2*wall_t, box_h - plate_t]);
    }

    // Screw holes through top plate
    for (i = [0:3])
        rotate([0, 0, 90*i])
            translate([0, 0, -eps])
                cylinder(d = screw_d, h = plate_t + 2*eps);

    // Cable notch in one wall (from open edge inward)
    translate([notch_x - notch_w/2, outer_y/2 - notch_w/2, box_h - notch_depth])
        cube([notch_w, notch_w, notch_depth + eps]);
}