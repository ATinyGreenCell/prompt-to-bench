// Two-part enclosure for a small electronics board (Arduino temp logger)
// Part 1: open box, Part 2: lid printed upside down, side by side on the bed.
// Units: mm. Print orientation: both parts rest on the XY plane at z = 0.

// ---- Named dimensions (measured with calipers) ----
box_outer_x   = 70.0;   // box outer length (X)
box_outer_y   = 50.0;   // box outer width  (Y)
box_outer_z   = 30.0;   // box outer height (Z)
wall_t        = 2.0;    // wall thickness
floor_t       = 2.0;    // floor thickness
lid_plate_t   = 2.0;    // lid plate thickness
lid_lip_t     = 1.5;    // lid lip wall thickness
lid_lip_h     = 4.0;    // lid lip height
lid_lip_outer_x = 65.6; // lip outer length (X)
lid_lip_outer_y = 45.6; // lip outer width  (Y)
gap           = 10.0;   // gap between the two parts on the bed

// Derived values
box_inner_x   = box_outer_x - 2 * wall_t;   // 66
box_inner_y   = box_outer_y - 2 * wall_t;   // 46
box_inner_z   = box_outer_z - floor_t;      // 28 (interior height)
lip_inner_x   = lid_lip_outer_x - 2 * lid_lip_t; // 62.6
lip_inner_y   = lid_lip_outer_y - 2 * lid_lip_t; // 42.6

// ---- Part 1: the box (open top), centred on the origin ----
module box() {
    // Outer shell
    cube([box_outer_x, box_outer_y, box_outer_z], center = [0, 0, box_outer_z / 2]);
    difference() {
        // Interior cavity, open at the top (cavity extends 1 mm above the rim)
        cube([box_inner_x, box_inner_y, box_inner_z + 1],
             center = [0, 0, floor_t + box_inner_z / 2]);
    }
}

// ---- Part 2: the lid, printed upside down ----
// Plate lies flat on the bed (z 0..2). The lip is a 1.5 mm wall, 4 mm tall,
// centred on the plate, with a 0.2 mm clearance per side vs. the box opening.
module lid() {
    // Plate
    cube([box_outer_x, box_outer_y, lid_plate_t], center = [0, 0, lid_plate_t / 2]);
    // Lip: outer wall minus inner void (void extends 1 mm above the lip top)
    difference() {
        cube([lid_lip_outer_x, lid_lip_outer_y, lid_lip_h],
             center = [0, 0, lid_plate_t + lid_lip_h / 2]);
        cube([lip_inner_x, lip_inner_y, lid_lip_h + 1],
             center = [0, 0, lid_plate_t + lid_lip_h / 2]);
    }
}

// ---- Place both parts side by side on the bed, 10 mm apart ----
// Box centred at origin; lid on the +X side, centred at (115, 25).
box();
translate([115, 25, 0]) lid();