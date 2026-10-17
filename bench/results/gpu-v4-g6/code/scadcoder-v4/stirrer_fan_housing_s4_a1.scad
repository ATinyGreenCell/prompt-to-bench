// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: upside down open box, top plate on bed (z = 0 to 2)
// Walls rise from top plate to open edge at z = 40

$fn = 64;

// ---- Dimensions (mm) ----
top_thickness      = 2;     // top plate thickness (z = 0 to 2)
wall_thickness     = 2.5;   // wall thickness
box_height         = 40;    // total height to open edge (z = 0 to 40)
outer_size         = 90;    // outer size in X and Y
screw_hole_count   = 4;     // number of M4 screw holes
screw_hole_d       = 4.5;   // screw hole diameter
screw_hole_pitch   = 71.5;  // square pitch between hole centres
cable_notch_w      = 12;    // cable notch width
cable_notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps                = 0.5;   // overcut for clean differences

// ---- Model ----
difference() {
    union() {
        // Top plate
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, top_thickness]);

        // Four walls rising from top plate, open at top
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_size/2 - wall_thickness : -outer_size/2,
                       sy > 0 ? outer_size/2 - wall_thickness : -outer_size/2,
                       top_thickness])
                cube([wall_thickness, wall_thickness, box_height - top_thickness]);
    }

    // Screw holes through top plate, centred on plate
    for (i = [0 : screw_hole_count - 1]) {
        a = (i - (screw_hole_count - 1)/2) * screw_hole_pitch;
        translate([a, a, -eps])
            cylinder(d = screw_hole_d, h = top_thickness + 2*eps);
    }

    // Cable notch in one wall, centred along wall, open edge to z = 40
    translate([outer_size/2 - wall_thickness - cable_notch_w/2,
               0,
               box_height - top_thickness - cable_notch_depth])
        cube([cable_notch_w, outer_size + 2*eps, cable_notch_depth + eps]);
}