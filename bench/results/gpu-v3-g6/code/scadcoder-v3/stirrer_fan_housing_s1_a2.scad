// Housing for a DIY magnetic stirrer built from an 80 mm PC case fan
// Printed upside down: top plate on the bed, box open at the top.

$fn = 64;

// ---- Dimensions (mm) ----
housing_outer  = 90;    // housing outer size (X x Y)
top_thick      = 2;     // top plate thickness (z = 0 to 2)
wall_thick     = 2.5;   // wall thickness
box_height     = 40;    // total height of box walls (open top at z = 40)
screw_pitch    = 71.5;  // square pitch of M4 screw holes
screw_d        = 4.5;   // M4 screw hole diameter
cable_w        = 12;    // cable notch width
cable_reach    = 8;     // notch depth from open edge (z = 32 to 40)

eps            = 0.5;   // cutter overshoot past faces

difference() {
    union() {
        // Top plate
        translate([-housing_outer/2, -housing_outer/2, 0])
            cube([housing_outer, housing_outer, top_thick]);
        // Four walls
        for (x = [-1, 1])
            for (y = [-1, 1])
                translate([x*housing_outer/2, y*housing_outer/2, 0])
                    cube([wall_thick, housing_outer, box_height]);
    }

    // M4 screw holes through top plate
    for (x = [-1, 1])
        for (y = [-1, 1])
            translate([x*screw_pitch/2, y*screw_pitch/2, -eps])
                cylinder(d = screw_d, h = top_thick + 2*eps);

    // Cable notch in one wall (X+ wall), centred along the wall
    translate([housing_outer/2, 0, box_height - cable_reach])
        cube([cable_w, housing_outer, cable_reach + eps]);
}