// DIY magnetic stirrer housing for an 80 mm PC case fan.
// Modelled in print orientation: the 2 mm top plate lies on the bed (z = 0..2)
// and four 2.5 mm walls rise from it to z = 40, leaving the box open at the top.
// Outer footprint is 90 x 90 mm, centred on the origin in X and Y.

// ---- Dimensions (mm) ----
outer_x   = 90;   // outer size in X
outer_y   = 90;   // outer size in Y
wall_t    = 2.5;  // wall thickness
top_t     = 2;    // top plate thickness (sits on the bed)
wall_h    = 40;   // total height of the walls (z = 0 .. 40)

hole_d    = 4.5;  // M4 clearance hole diameter
hole_pitch= 71.5; // square pitch of the four mounting holes
hole_off  = hole_pitch / 2; // offset of each hole from centre

notch_w   = 12;   // power-cable notch width
notch_top = 40;   // notch reaches the open edge
notch_bot = 32;   // notch bottom (8 mm down from the open edge)

$fn = 64;         // smooth round holes

// ---- Base solid: top plate + four walls (open at the top) ----
base = union() {
    // Top plate (bed side, z = 0 .. 2)
    translate([0, 0, 0])
        cube([outer_x, outer_y, top_t], center = true);

    // Four walls rising from the plate to z = 40
    // Front wall  (negative Y side)
    translate([0, -(outer_y/2 - wall_t/2), 0])
        cube([outer_x, wall_t, wall_h], center = true);
    // Back wall   (positive Y side)
    translate([0,  (outer_y/2 - wall_t/2), 0])
        cube([outer_x, wall_t, wall_h], center = true);
    // Left wall   (negative X side)
    translate([-(outer_x/2 - wall_t/2), 0, 0])
        cube([wall_t, outer_y, wall_h], center = true);
    // Right wall  (positive X side)
    translate([ (outer_x/2 - wall_t/2), 0, 0])
        cube([wall_t, outer_y, wall_h], center = true);
};

// ---- Cutters ----
// Four M4 mounting holes through the top plate (71.5 mm square pattern).
// Each cylinder extends 1 mm past both faces of the 2 mm plate (z = -1 .. 3).
mounting_holes = for (dx = [-hole_off, hole_off],
                     dy = [-hole_off, hole_off])
    translate([dx, dy, 0])
        cylinder(h = top_t + 2, r = hole_d / 2, center = true);

// Power-cable notch in the front wall.
// 12 mm wide, centred on the wall, z = 32 .. 40, cut through the wall thickness.
cable_notch = translate([0, -(outer_y/2 - wall_t/2), (notch_bot + notch_top)/2])
    cube([notch_w, wall_t + 2, notch_top - notch_bot], center = true);

// ---- Final part ----
difference() {
    base;
    mounting_holes;
    cable_notch;
}