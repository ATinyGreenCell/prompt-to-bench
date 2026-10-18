// DIY magnetic stirrer housing (print orientation: top plate down, box open upward)
// Units: mm

// ---------- Parameters ----------
outer_size      = 90;    // outer length and width (X, Y)
top_plate_t     = 2;     // top plate thickness (z = 0 to 2)
wall_t          = 2.5;   // wall thickness
open_top_z      = 40;    // height of open top (walls run z = 2 to 40)
hole_d          = 4.5;   // screw hole diameter (M4)
hole_pattern    = 71.5;  // square pitch of screw holes
hole_count      = 4;     // number of screw holes
notch_w         = 12;    // cable notch width
notch_bottom_z  = 32;    // notch floor (8 mm up from open edge, which is at z = 40)
eps             = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Top plate (lies on the bed)
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, top_plate_t]);

        // Four walls rising from the plate to the open top
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_size/2 - wall_t : -outer_size/2,
                       sy > 0 ? outer_size/2 - wall_t : -outer_size/2,
                       top_plate_t])
                cube([wall_t, wall_t, open_top_z - top_plate_t]);
    }

    // Screw holes through the top plate on a centred square pattern
    for (i = [0 : hole_count - 1]) {
        x = -hole_pattern/2 + (i + 0.5) * hole_pattern / hole_count;
        y = -hole_pattern/2 + (i + 0.5) * hole_pattern / hole_count;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = top_plate_t + 2*eps);
    }

    // Cable notch cut into one wall, reaching up from z = 32 to the open edge
    translate([-outer_size/2 - eps, -outer_size/2 - eps, notch_bottom_z])
        cube([notch_w + 2*eps, outer_size + 2*eps, open_top_z - notch_bottom_z]);
}