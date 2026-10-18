// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising to z = 70.
// After printing, flip the part so the walls stand on the bed and the
// tube holes face downward.
//
// Units: mm. No external libraries.

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0..4)

hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // rows along Y
hole_pitch   = 40;    // centre-to-centre spacing (X and Y)

wall_t       = 4;     // wall thickness (Y)
wall_h       = 70;    // wall height from top of plate (z = 4..74)

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// Derived
wall_top_z   = plate_t + wall_h;   // 74
x0           = -(hole_nx - 1) * hole_pitch / 2;  // first hole X
y0           = -(hole_ny - 1) * hole_pitch / 2;  // first hole Y

// ---------------- Model ----------------
union() {
    // Base plate
    translate([-plate_x / 2, -plate_y / 2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges (flush with plate)
    for (sx = [-1, 1])
        translate([sx > 0 ? plate_x / 2 - wall_t : -plate_x / 2,
                   -wall_t, 0])
            cube([wall_t, wall_h + plate_t, wall_top_z]);
}

// ---------------- Tube holes ----------------
// Drilled in print orientation; after flipping they become the open
// top of the rack, so the tubes drop straight in.
difference() {
    // Walls + plate (no coplanar faces thanks to eps)
    union() {
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x / 2 - wall_t : -plate_x / 2,
                       -wall_t, 0])
                cube([wall_t, wall_h + plate_t, wall_top_z]);
        translate([-plate_x / 2, -plate_y / 2, 0])
            cube([plate_x, plate_y, plate_t + eps]);
    }

    // 2 x 3 grid of through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([x0 + i * hole_pitch, y0 + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = wall_top_z + 2 * eps);
}