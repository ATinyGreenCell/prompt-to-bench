// DIY magnetic stirrer housing - print orientation (upside down)
// Units: mm. Print orientation: top plate on bed (z = 0), walls rise to z = 40.

// ---------------- Parameters ----------------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height of box (open top at z = box_h)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
screw_d      = 4.5;   // M4 screw hole diameter
screw_pitch  = 71.5;  // square pitch of screw holes (centre to centre)
notch_w      = 12;    // cable notch width (along wall)
notch_depth  = 8;     // notch depth from open edge (z = box_h - notch_depth)
eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main box body: solid block with open top
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, box_h]);

    // Top plate (thick, forms the stirring surface when flipped)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, plate_t]);

    // Four walls, each with a small window cut near the open top
    // Wall along +X, running Y - to +
    translate([-outer_x/2 + wall_t, -outer_y/2, 0])
        cube([outer_x - 2*wall_t, outer_y, box_h]);

    // Wall along -X, running Y - to +
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x - 2*wall_t, outer_y, box_h]);

    // Wall along +Y, running X - to +
    translate([-outer_x/2, -outer_y/2 + wall_t, 0])
        cube([outer_x, outer_y - 2*wall_t, box_h]);

    // Wall along -Y, running X - to +
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y - 2*wall_t, box_h]);

    // Screw holes through the top plate, on a centred square pattern
    for (i = [0:3]) {
        rotate([0, 0, i*90])
            translate([0, 0, -eps])
                cylinder(d = screw_d, h = plate_t + 2*eps);
    }

    // Cable notch in one wall: 12 mm wide, centred along the wall,
    // reaching 8 mm down from the open edge (z = 32 to z = 40)
    translate([-outer_x/2 + wall_t, -outer_y/2 + outer_y/2 - notch_w/2,
               box_h - notch_depth])
        cube([notch_w, outer_y - 2*wall_t, notch_depth]);
}