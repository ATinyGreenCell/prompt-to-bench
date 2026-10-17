// DIY magnetic stirrer housing for an 80 mm PC case fan
// Print orientation: upside-down open box, top plate on bed (z = 0 to 2)

// ---------- Parameters ----------
top_thickness      = 2;     // top plate thickness
wall_thickness     = 2.5;   // wall thickness
box_height         = 40;    // total height of walls (z = 0 to 40)
outer_size         = 90;    // outer size in X and Y
screw_hole_d       = 4.5;   // M4 screw hole diameter
screw_hole_pitch   = 71.5;  // square pitch of screw holes
cable_notch_w      = 12;    // cable notch width
cable_notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps                = 0.5;   // overcut for clean differences
$fn                = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, top_thickness]);

        // Four walls rising from the plate
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_size/2 - wall_thickness : -outer_size/2,
                       sy > 0 ? outer_size/2 - wall_thickness : -outer_size/2,
                       top_thickness])
                cube([wall_thickness, wall_thickness, box_height - top_thickness]);
    }

    // Four M4 screw holes through the top plate
    for (x = [-screw_hole_pitch/2, screw_hole_pitch/2],
         y = [-screw_hole_pitch/2, screw_hole_pitch/2])
        translate([x, y, -eps])
            cylinder(d = screw_hole_d, h = top_thickness + 2*eps);

    // Cable notch in one wall (centred along the wall)
    translate([outer_size/2 - wall_thickness - cable_notch_w/2,
               0,
               box_height - top_thickness - cable_notch_depth])
        cube([cable_notch_w, wall_thickness, cable_notch_depth + eps]);
}