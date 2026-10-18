// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising to z = 70
// After printing, flip over so the rack stands on the walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length (X)
plate_y      = 90;    // plate width (Y)
plate_t      = 4;     // plate thickness (Z)

hole_d       = 30.5;  // tube hole diameter
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing (X and Y)

wall_t       = 4;     // wall thickness (Y)
wall_h       = 70;    // wall height above plate (Z)

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;             // hole resolution

// ---------- Derived ----------
wall_x0 = 0;          // wall start (X)
wall_x1 = plate_x - wall_t;  // wall end (X), flush with long edge

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two long-edge walls
        for (sx = [0, 1])
            translate([sx * wall_x1 - wall_x0, -wall_t/2, plate_t])
                cube([wall_x1 - wall_x0, wall_t, wall_h]);
    }

    // Tube holes, centred on plate
    for (i = [0 : hole_ny - 1])
        for (j = [0 : hole_nx - 1])
            translate([(j - (hole_nx - 1)/2) * hole_pitch,
                       (i - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}