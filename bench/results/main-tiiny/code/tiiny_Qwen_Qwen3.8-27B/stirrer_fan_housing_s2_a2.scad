// DIY magnetic stirrer housing for an 80 mm PC case fan
// Printed upside-down: the 2 mm top plate (stirring surface) lies on the bed,
// four 2.5 mm walls rise to z = 40, and the box is open at the top.

// ---- Dimensions (mm) ----
plate_t   = 2;    // top plate thickness (z = 0 .. 2)
wall_t    = 2.5;  // wall thickness
wall_h    = 40;   // wall height (z = 0 .. 40)
outer_x   = 90;   // outer size in X
outer_y   = 90;   // outer size in Y

hole_d    = 4.5;  // M4 clearance hole diameter
hole_pitch= 71.5; // square pitch of the four mounting holes

notch_w   = 12;   // power-cable notch width
notch_top = 40;   // notch reaches the open edge
notch_bot = 32;   // notch bottom (8 mm down from the open edge)

$fn = 64;         // round holes

// ---- Base: 2 mm plate + four 2.5 mm walls (open at z = 40) ----
base = union() {
    // top plate (stirring surface)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, plate_t]);

    // four walls, 2.5 mm thick, rising to z = wall_h
    // front wall  (y = -outer_y/2 .. -outer_y/2 + wall_t)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, wall_t, wall_h]);
    // back wall   (y = outer_y/2 - wall_t .. outer_y/2)
    translate([-outer_x/2, outer_y/2 - wall_t, 0])
        cube([outer_x, wall_t, wall_h]);
    // left wall   (x = -outer_x/2 .. -outer_x/2 + wall_t)
    translate([-outer_x/2, -outer_y/2 + wall_t, 0])
        cube([wall_t, outer_y - 2*wall_t, wall_h]);
    // right wall  (x = outer_x/2 - wall_t .. outer_x/2)
    translate([outer_x/2 - wall_t, -outer_y/2 + wall_t, 0])
        cube([wall_t, outer_y - 2*wall_t, wall_h]);
};

// ---- Cutters ----
// Four 4.5 mm holes through the top plate on a 71.5 mm square pattern.
// Each cylinder extends 1 mm past both faces of the 2 mm plate (z = -1 .. 3).
screw_holes = for (sx = [-1, 1], sy = [-1, 1])
    translate([sx * hole_pitch/2, sy * hole_pitch/2, -1])
        cylinder(h = plate_t + 2, d = hole_d);

// Power-cable notch in the front wall, 12 mm wide, centred, z = 32 .. 40.
// The cutter is 1 mm wider than the wall so it fully opens the wall.
cable_notch = translate([0, -outer_y/2 - 0.5, notch_bot])
    cube([notch_w, wall_t + 1, notch_top - notch_bot]);

// ---- Final part ----
difference() {
    base;
    screw_holes;
    cable_notch;
}