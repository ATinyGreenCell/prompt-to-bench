// DIY magnetic stirrer housing for an 80 mm PC case fan.
// Modelled in print orientation: the 2 mm top plate (stirring surface)
// lies flat on the bed (z = 0..2) and the four 2.5 mm walls rise to z = 40,
// leaving the box open at the top.

// ---- Dimensions (mm) ----
outer_x   = 90;   // outer size along X
outer_y   = 90;   // outer size along Y
wall_t    = 2.5;  // wall thickness
top_t     = 2;    // top plate thickness (stirring surface)
wall_h    = 40;   // wall height above the top plate (open edge at z = 40)

hole_d    = 4.5;  // M4 clearance hole diameter
hole_pitch= 71.5; // square pitch of the four mounting holes (centred)

notch_w   = 12;   // power-cable notch width
notch_top = 40;   // notch reaches the open edge
notch_bot = 32;   // notch bottom (8 mm down from the open edge)

$fn = 64;         // smooth round holes

// ---- Base: top plate + four walls (open box, printed upside down) ----
module base() { union() {
    // top plate on the bed
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, top_t]);

    // four walls rising from the top plate
    // front wall (negative Y side)
    translate([-outer_x/2, -outer_y/2, top_t])
        cube([outer_x, wall_t, wall_h]);
    // back wall (positive Y side)
    translate([-outer_x/2, outer_y/2 - wall_t, top_t])
        cube([outer_x, wall_t, wall_h]);
    // left wall (negative X side)
    translate([-outer_x/2, -outer_y/2 + wall_t, top_t])
        cube([wall_t, outer_y - 2*wall_t, wall_h]);
    // right wall (positive X side)
    translate([outer_x/2 - wall_t, -outer_y/2 + wall_t, top_t])
        cube([wall_t, outer_y - 2*wall_t, wall_h]);
} }

// ---- Cutters ----
// four M4 mounting holes through the top plate (71.5 mm square, centred)
module mounting_holes() { for (dx = [-hole_pitch/2, hole_pitch/2],
                      dy = [-hole_pitch/2, hole_pitch/2])
    translate([dx, dy, -1])
        cylinder(h = top_t + 2, r = hole_d/2, $fn = $fn); }

// power-cable notch in one wall (front wall, centred along it)
module cable_notch() { translate([0, -outer_y/2 - 1, notch_bot])
    cube([notch_w, wall_t + 2, notch_top - notch_bot + 1]); }

// ---- Final part ----
difference() {
    base();
    mounting_holes();
    cable_notch();
}