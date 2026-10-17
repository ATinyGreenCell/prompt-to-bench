// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising up (+Z)
// After printing, flip over so the rack stands on the two walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // number of rows along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y

wall_len     = 130;   // wall length along X
wall_t       = 4;     // wall thickness along Y
wall_h       = 70;    // wall height from plate (z = 4 to 74)

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // circle resolution

// ---------- Derived ----------
wall_top_z   = plate_t + wall_h;   // top of walls (z = 74)
x0           = -(hole_nx - 1) * hole_pitch / 2;  // first hole X
y0           = -(hole_ny - 1) * hole_pitch / 2;  // first hole Y

// ---------- Model ----------
union() {
    // Base plate
    translate([-plate_x / 2, -plate_y / 2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges
    for (s = [-1, 1])
        translate([s > 0 ? plate_x / 2 - wall_t : -plate_x / 2,
                   -wall_t / 2, 0])
            cube([wall_len, wall_t, wall_top_z]);

    // Tube through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([x0 + i * hole_pitch, y0 + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}