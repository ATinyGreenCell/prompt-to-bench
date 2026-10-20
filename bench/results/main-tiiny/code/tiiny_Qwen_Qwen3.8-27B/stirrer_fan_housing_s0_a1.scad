// Housing for a DIY magnetic stirrer built from an 80 mm PC case fan.
// Modelled in print orientation: the 2 mm top plate lies on the bed (z = 0..2)
// and the four 2.5 mm walls rise from it to z = 40, leaving the box open at the top.

$fn = 64;

// ---- Dimensions (mm) ----
outer_x   = 90;   // outer size in X
outer_y   = 90;   // outer size in Y
wall_thk  = 2.5;  // wall thickness
top_thk   = 2;    // top plate thickness
wall_h    = 40;   // total height of the walls (z = 0 .. 40)

hole_d    = 4.5;  // M4 clearance hole diameter
hole_pitch= 71.5; // square pitch of the fan mounting holes (centred on plate)

notch_w   = 12;   // power-cable notch width
notch_top = 40;   // notch reaches the open edge
notch_bot = 32;   // notch bottom (8 mm down from the open edge)

// ---- Base solid: top plate + four walls ----
base = union() {
    // Top plate (rests on the bed, z = 0 .. 2)
    translate([0, 0, 0])
        cube([outer_x, outer_y, top_thk], center = true);

    // Four walls rising from the plate to z = wall_h
    // +X wall (outer face at x = +outer_x/2)
    translate([ outer_x/2 - wall_thk/2, 0, wall_h/2])
        cube([wall_thk, outer_y, wall_h], center = true);
    // -X wall (outer face at x = -outer_x/2)
    translate([-outer_x/2 + wall_thk/2, 0, wall_h/2])
        cube([wall_thk, outer_y, wall_h], center = true);
    // +Y wall (outer face at y = +outer_y/2)
    translate([0,  outer_y/2 - wall_thk/2, wall_h/2])
        cube([outer_x, wall_thk, wall_h], center = true);
    // -Y wall (outer face at y = -outer_y/2)
    translate([0, -outer_y/2 + wall_thk/2, wall_h/2])
        cube([outer_x, wall_thk, wall_h], center = true);
};

// ---- Cuts ----
// 1) Four 4.5 mm holes through the top plate on a 71.5 mm square pattern.
//    Each cylinder extends 1 mm past the plate faces (z = -1 .. 3) so the
//    cut is not coplanar with the plate top/bottom.
screw_holes = for (dx = [-hole_pitch/2, hole_pitch/2],
                   dy = [-hole_pitch/2, hole_pitch/2])
    translate([dx, dy, 0])
        cylinder(h = top_thk + 2, r = hole_d/2, center = false);

// 2) Power-cable notch in the +X wall, centred along that wall.
//    The cutter extends 1 mm past the wall's outer face (x = 45) and 1 mm
//    past the open edge (z = 41) so no faces are exactly coplanar.
cable_notch = translate([outer_x/2 + 1, 0, (notch_bot + notch_top)/2])
    cube([2, notch_w, notch_top - notch_bot], center = true);

// ---- Final part ----
difference() {
    base;
    screw_holes;
    cable_notch;
}