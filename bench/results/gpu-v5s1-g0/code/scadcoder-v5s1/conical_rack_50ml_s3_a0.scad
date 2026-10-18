// Rack for six 50 mL conical (Falcon-type) tubes
// Print upside down, flip over after printing.

// ---- Plate ----
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

// ---- Holes ----
hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing both directions
hole_overlap = 0.01;  // cutter extends past top/bottom faces

// ---- Walls ----
wall_h       = 70;    // wall top height (z = 0 to 70)

// ---- Resolution ----
$fn = 128;

difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along long edges, flush, rising to z = 70
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - 1 : -plate_x/2, -plate_y/2, 0])
                cube([1 + plate_x/2 - s > 0 ? plate_x/2 - 1 : 1, plate_y, wall_h]);
    }

    // Through-holes, centred on plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -hole_overlap])
                cylinder(d = hole_d, h = plate_t + 2 * hole_overlap);
}