// Magnetic stirrer housing - upside-down open box over a 80 mm PC fan
// Print orientation: top plate on the bed (z = 0), walls rise to z = 40

$fn = 64;

// ---- Dimensions (mm) ----
box_outer_x      = 90;    // outer size in X
box_outer_y      = 90;    // outer size in Y
top_plate_t      = 2;     // top plate thickness (z = 0 to 2)
wall_t           = 2.5;   // wall thickness
wall_top_z       = 40;    // open top of box (z)
screw_hole_d     = 4.5;   // M4 screw hole diameter
screw_hole_pitch = 71.5;  // square pattern size for holes
cable_notch_w    = 12;    // notch width for power cable
cable_notch_bot  = 8;     // notch depth from open edge (z = 32 to 40)
eps              = 0.5;   // overshoot for clean cuts

difference() {
    // Main box body
    union() {
        // Top plate
        translate([-box_outer_x/2, -box_outer_y/2, 0])
            cube([box_outer_x, box_outer_y, top_plate_t]);
        // Four walls from top plate up to open top
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? box_outer_x/2 - wall_t : -box_outer_x/2,
                       sy > 0 ? box_outer_y/2 - wall_t : -box_outer_y/2,
                       0])
                cube([wall_t, box_outer_y - box_outer_x + 2*wall_t,
                      wall_top_z - top_plate_t]);
    }

    // Screw holes through top plate, centred on plate
    for (i = [0 : 3])
        translate([(i < 2 ? -1 : 1) * screw_hole_pitch/2,
                   (i >= 2 ? -1 : 1) * screw_hole_pitch/2,
                   top_plate_t/2])
            cylinder(d = screw_hole_d, h = top_plate_t + eps);

    // Cable notch in one wall, centred along the wall
    translate([box_outer_x/2 - wall_t, 0, wall_top_z - cable_notch_bot])
        cube([wall_t, cable_notch_w, cable_notch_bot + eps]);
}