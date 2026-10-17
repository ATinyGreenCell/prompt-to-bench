// Housing for a DIY magnetic stirrer built from an 80 mm PC case fan
// Printed upside down: top plate on the bed, box open at the top.

$fn = 64;

// ---- Dimensions (mm) ----
housing_outer  = 90;    // housing outer size (X x Y)
top_thick      = 2;     // top plate thickness (z = 0 to 2)
wall_thick     = 2.5;   // wall thickness
total_h       = 40;     // overall height (top of walls)
cable_h       = 8;     // cable notch depth from open edge (z = 32 to 40)
screw_pitch   = 71.5;   // square pitch for M4 screw holes
screw_d       = 4.5;    // M4 screw hole diameter

eps           = 0.5;   // cutter overshoot past faces

difference() {
    union() {
        // Top plate
        translate([-housing_outer/2, -housing_outer/2, 0])
            cube([housing_outer, housing_outer, top_thick]);
        // Four walls
        for (x = [-1, 1])
            for (y = [-1, 1])
                translate([x * housing_outer/2, y * housing_outer/2, 0])
                    cube([wall_thick, housing_outer, total_h]);
    }

    // M4 screw holes through top plate, centred on plate
    for (x = [-screw_pitch/2, screw_pitch/2])
        for (y = [-screw_pitch/2, screw_pitch/2])
            translate([x, y, -eps])
                cylinder(d = screw_d, h = top_thick + 2*eps);

    // Cable notch in one wall, centred along the wall
    translate([housing_outer/2 - 6, 0, total_h - cable_h])
        cube([12, housing_outer, cable_h + eps]);
}