// ============================================================================
// Two-part enclosure for a small electronics board (e.g. Arduino temp logger)
// Both parts print on the same bed, side by side, 10 mm gap between them.
// Units: millimetres.
// ============================================================================

$fn = 64;

// ---------------- Part 1: Box (open top) ----------------
box_outer_x = 70;   // outer width  (X)
box_outer_y = 50;   // outer depth  (Y)
box_outer_z = 30;   // outer height (Z)
box_wall    = 2;    // wall thickness
box_floor   = 2;    // floor thickness

// ---------------- Part 2: Lid (printed upside down) ----------------
lid_plate_x = 70;   // plate width  (X)
lid_plate_y = 50;   // plate depth  (Y)
lid_plate_z = 2;    // plate thickness (Z)
lid_wall    = 1.5;  // lip wall thickness
lip_h       = 4;    // lip height (Z)
// Lip outer size: 65.6 x 45.6  (0.2 mm clearance per side vs box inner 66 x 46)
lip_outer_x = 65.6;
lip_outer_y = 45.6;

// ---------------- Layout on the bed ----------------
// Box centred at origin in X,Y; lid on +X side with 10 mm gap.
gap = 10;
lid_x_offset = box_outer_x / 2 + gap + lid_plate_x / 2;  // 35 + 10 + 35 = 80

// ============================================================================
// Part 1: Box
// ============================================================================
module box() {
    // Outer solid block
    outer = cube([box_outer_x, box_outer_y, box_outer_z], center = true);

    // Cavity: 2 mm walls, 2 mm floor, open top.
    // Cavity extends 1 mm above the top face so the cut is clean (no coplanar faces).
    cav_x = box_outer_x - 2 * box_wall;   // 66
    cav_y = box_outer_y - 2 * box_wall;   // 46
    cav_z = box_outer_z - box_floor;      // 28  (height of cavity from floor top)

    // Cavity bottom sits at z = box_floor (top of floor).
    // Cavity top extends 1 mm above box_outer_z to guarantee a clean open top.
    cav_h = box_outer_z - box_floor + 1;  // 29

    difference() {
        outer;
        translate([0, 0, box_floor])
            cube([cav_x, cav_y, cav_h], center = [true, true, false]);
    }
}

// ============================================================================
// Part 2: Lid (printed upside down: plate on bed, lip on top)
// ============================================================================
module lid() {
    // Plate: 70 x 50 x 2, centred in X,Y, resting on z=0
    plate = cube([lid_plate_x, lid_plate_y, lid_plate_z], center = [true, true, false]);

    // Lip: 1.5 mm thick wall, 4 mm tall, outer 65.6 x 45.6, centred on plate.
    // Lip sits on top of the plate (z from lid_plate_z to lid_plate_z + lip_h).
    lip_outer = cube([lip_outer_x, lip_outer_y, lip_h], center = [true, true, false]);
    lip_inner_x = lip_outer_x - 2 * lid_wall;   // 62.6
    lip_inner_y = lip_outer_y - 2 * lid_wall;   // 42.6
    // Inner cavity of lip extends 1 mm above the lip top for a clean cut.
    lip_inner_h = lip_h + 1;

    lip = difference() {
        lip_outer;
        translate([0, 0, 0])
            cube([lip_inner_x, lip_inner_y, lip_inner_h], center = [true, true, false]);
    };

    union() {
        plate;
        translate([0, 0, lid_plate_z])
            lip;
    }
}

// ============================================================================
// Assemble both parts on the bed
// ============================================================================
// Box centred at origin
box();

// Lid on +X side, 10 mm gap between outer faces
translate([lid_x_offset, 0, 0])
    lid();