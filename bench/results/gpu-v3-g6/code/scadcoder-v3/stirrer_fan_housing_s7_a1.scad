// Housing for a DIY magnetic stirrer built around an 80 mm PC case fan
// Printed upside down: top plate on the bed, box open at the top.

$fn = 64;

// ---- Dimensions (mm) ----
top_t      = 2;    // top plate thickness (z = 0 to 2)
wall_t     = 2.5;  // wall thickness
box_h      = 40;   // total height of box walls (open top at z = 40)
outer_x    = 90;   // outer size along X
outer_y    = 90;   // outer size along Y
screw_n    = 4;    // number of screw holes
screw_d    = 4.5;  // screw hole diameter (M4)
screw_pitch = 71.5;// square pitch of screw holes (X and Y)
cable_w    = 12;   // width of power-cable notch
cable_reach = 8;   // notch depth from open edge (z = 32 to 40)

// ---- Model ----
difference() {
    // Outer box
    union() {
        cube([outer_x, outer_y, top_t]);           // top plate
        cube([outer_x, outer_y, box_h]);           // walls (overlaps plate)
    }

    // Inner cavity, leaving the specified wall thickness
    translate([wall_t, wall_t, top_t])
        cube([outer_x - 2 * wall_t, outer_y - 2 * wall_t, box_h - top_t]);

    // M4 screw holes through the top plate
    for (i = [0 : screw_n - 1])
        rotate([0, 0, 90 * i])
            translate([screw_pitch / 2, 0, -1])
                cylinder(d = screw_d, h = top_t + 2, $fn = 64);

    // Power-cable notch in one wall (12 mm wide, from z = 32 to 40)
    translate([outer_x / 2 - cable_w / 2, outer_y / 2, box_h - cable_reach])
        cube([cable_w, outer_y, cable_reach]);
}