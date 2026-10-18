// DIY magnetic stirrer housing - print orientation (upside down)
// Units: mm. Print orientation: top plate on bed (z = 0), walls rise to z = 40.

// ---------------- Parameters ----------------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total box height (open top at z = box_h)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
screw_d      = 4.5;   // M4 screw hole diameter
screw_pitch  = 71.5;  // square screw hole pattern size (X and Y)
notch_w      = 12;    // cable notch width (along wall, centred)
notch_depth  = 8;     // notch depth from open edge (z = box_h - notch_depth)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Main box: solid block, open at top
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, box_h]);

    // Top plate (lies on bed, z = 0 to plate_t)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, plate_t]);

    // Four walls, each with a cut for the fan (80 x 80 mm, centred)
    // Walls run from z = plate_t up to z = box_h
    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([sx * (outer_x/2 - wall_t),
                   sy * (outer_y/2 - wall_t),
                   plate_t])
            difference() {
                cube([wall_t, outer_y - 2*wall_t, box_h - plate_t]);   // X wall
                translate([0, -fan_d/2, 0])
                    cube([wall_t + eps, fan_d, box_h - plate_t + eps]);
            }
        translate([sx * (outer_x/2 - wall_t),
                   sy * (outer_y/2 - wall_t),
                   plate_t])
            difference() {
                cube([outer_x - 2*wall_t, wall_t, box_h - plate_t]);   // Y wall
                translate([-fan_d/2, 0, 0])
                    cube([box_h - plate_t + eps, wall_t + eps, fan_d]);
            }
    }

    // Screw holes through top plate on 71.5 mm square pattern
    for (x = [-screw_pitch/2, screw_pitch/2])
        for (y = [-screw_pitch/2, screw_pitch/2])
            translate([x, y, 0])
                cylinder(d = screw_d, h = plate_t + eps);

    // Cable notch in one wall: 12 mm wide, centred along wall,
    // reaching 8 mm down from the open edge (z = 32 to z = 40)
    translate([-outer_x/2 + wall_t, 0, box_h - notch_depth])
        cube([notch_w, outer_y - 2*wall_t, notch_depth + eps]);
}