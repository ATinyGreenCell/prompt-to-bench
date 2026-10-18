// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising above it.
// After printing, flip the part so the walls stand on the bed and the
// tube holes face upward.
//
// Units: mm. $fn = 64 for round holes.

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

hole_d       = 30.5;  // through-hole diameter
hole_count   = 6;     // number of tube holes
hole_pitch   = 40;    // centre-to-centre spacing (both X and Y)
hole_start_x = -65;   // first hole X (3 holes over 130 mm)
hole_start_y = -45;   // first hole Y (2 rows along Y)

wall_t       = 4;     // wall thickness (Y)
wall_h       = 70;    // wall height from bed (z = 0 to 70)

eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
union() {
    // Flat base plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges (flush with plate's long edge)
    for (sx = [-1, 1])
        translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                   -plate_y/2, 0])
            cube([wall_t, plate_y, wall_h]);
}

// ---------------- Tube holes ----------------
// Drilled while in print orientation; after flipping they face upward.
difference() {
    // (Copy of the rack body to keep a clean module structure)
    union() {
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -plate_y/2, 0])
                cube([wall_t, plate_y, wall_h]);
    }

    for (i = [0 : hole_count - 1]) {
        x = hole_start_x + i % 3 * hole_pitch;
        y = hole_start_y + floor(i / 3) * hole_pitch;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = plate_t + 2*eps);
    }
}