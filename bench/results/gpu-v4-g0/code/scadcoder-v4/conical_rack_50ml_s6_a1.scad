// Tube rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising up (+Z)
// After printing, flip the part over so it stands on the walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0 to 4

hole_d       = 30.5;  // through-hole diameter (mm)
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // number of rows along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y (mm)

wall_h       = 70;    // wall height above plate (mm), top at z = 74
wall_t       = 4;     // wall thickness along Y (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------- Derived ----------
first_x = -(hole_nx - 1) * hole_pitch / 2;  // first hole X (centres row)
first_y = -(hole_ny - 1) * hole_pitch / 2;  // first hole Y (centres rows)

// ---------- Model ----------
union() {
    // Base plate
    translate([-plate_x / 2, -plate_y / 2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges, flush with plate
    for (s = [-1, 1])
        translate([s > 0 ? plate_x / 2 - wall_t : -plate_x / 2,
                   -wall_t / 2, 0])
            cube([plate_x, wall_t, wall_h]);

    // Through-holes in the plate (walls remain solid)
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([first_x + i * hole_pitch,
                       first_y + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}