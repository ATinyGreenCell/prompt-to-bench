// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane, open top facing +Z

// ---------- Parameters ----------
outer_x      = 120;   // outer length (X)
outer_y      = 70;    // outer width (Y)
tank_h       = 40;    // outer height (Z)
wall         = 3;     // wall thickness
floor        = 3;     // floor thickness under inner volume
platform_x   = 60;    // platform length in X (centred)
platform_y   = outer_y; // platform spans full inner width
platform_top = 13;    // platform top height above inner floor
hole_d       = 2;     // electrode hole diameter
hole_y       = 0;     // electrode hole Y position
hole_z       = 30;    // electrode hole Z position

eps          = 0.5;   // cutter overshoot past faces
$fn          = 64;    // curve resolution

// ---------- Derived ----------
inner_h   = tank_h - floor;                    // inner floor-to-top height
platform_z = floor + platform_top;             // platform top (absolute Z)
chamber_h = inner_h - platform_top;            // chamber height above platform

// ---------- Model ----------
difference() {
    // Main tank body
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, tank_h]);

    // Central open channel (cut through, top to bottom)
    translate([-outer_x/2, -platform_y/2, floor])
        cube([outer_x, platform_y, tank_h - floor + eps]);

    // Raised platform for gel tray
    union() {
        translate([-platform_x/2, -platform_y/2, platform_z])
            cube([platform_x, platform_y, chamber_h + eps]);   // lower block
        translate([-platform_x/2, -platform_y/2, tank_h - wall])
            cube([platform_x, platform_y, wall + eps]);         // top cap
    }

    // Electrode holes through end walls, along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - hole_d : -outer_x/2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2*eps);
}