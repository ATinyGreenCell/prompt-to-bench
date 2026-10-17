// Housing for a DIY magnetic stirrer built from an 80 mm PC case fan
// Printed upside down: top plate on the bed, box open at the top.

$fn = 64;

// ---- Dimensions (mm) ----
top_t      = 2;    // top plate thickness (z = 0 to 2)
wall_t     = 2.5;  // wall thickness
box_h      = 40;   // total height of box walls (z = 0 to 40)
outer_x    = 90;   // outer size along X
outer_y    = 90;   // outer size along Y
screw_n    = 4;    // number of screw holes
screw_d    = 4.5;  // screw hole diameter (M4)
screw_pitch = 71.5;// square pitch of screw holes (X and Y)
cable_w    = 12;   // width of power cable notch
cable_reach = 8;   // notch depth from open edge (z = 32 to 40)

// ---- Model ----
difference() {
    // Outer box
    union() {
        // Top plate on the bed
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, top_t]);
        // Four walls rising from the plate
        translate([-outer_x/2, -outer_y/2, top_t])
            cube([outer_x, outer_y, box_h - top_t]);
    }

    // Four M4 screw holes through the top plate, centred on the plate
    for (i = [0 : screw_n - 1])
        translate([0, 0, -1])
            rotate([0, 90, 0])
                translate([screw_pitch/2 * [cos(i * 90), sin(i * 90)], 0])
                    cylinder(d = screw_d, h = top_t + 2);

    // Power cable notch in one wall, centred along the wall
    translate([-cable_w/2, -outer_y/2, top_t + box_h - cable_reach])
        cube([cable_w, outer_y + 2, cable_reach]);
}