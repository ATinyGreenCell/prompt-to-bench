// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, two walls along long edges
// After printing: flip over so rack stands on walls, tubes pass through holes

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // through-hole diameter (mm)
hole_nx      = 3;     // holes along X (per row)
hole_ny      = 2;     // holes along Y (rows)
hole_pitch   = 40;    // centre-to-centre spacing both directions (mm)

wall_t       = 4;     // wall thickness along Y (mm)
wall_top_z   = 70;    // walls rise from plate to this height (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------------- Derived ----------------
wall_h = wall_top_z - plate_t;   // wall height above plate (66 mm)

// ---------------- Model ----------------
union() {
    // Base plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along long edges, flush with plate
    for (sx = [-1, 1])
        translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                   -plate_y/2, 0])
            cube([wall_t, plate_y, wall_h]);

    // Through-holes in 2 rows (along Y) of 3 (along X)
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}