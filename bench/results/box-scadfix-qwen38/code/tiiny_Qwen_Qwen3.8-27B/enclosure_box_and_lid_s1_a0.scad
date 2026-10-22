// Two-part enclosure for a small electronics board (e.g. Arduino temperature logger)
// Both parts are modelled in their print orientation (resting on the XY plane at z = 0,
// building upward in +Z) and placed side by side with a 10 mm gap between them.

// ---------- Global ----------
$fn = 64;

// ---------- Part 1: Box ----------
box_outer_x = 70;   // outer width  (X)
box_outer_y = 50;   // outer depth  (Y)
box_outer_z = 30;   // outer height (Z)
box_wall    = 2;    // wall thickness
box_floor   = 2;    // floor thickness

// ---------- Part 2: Lid (printed upside down) ----------
lid_plate_x   = 70;    // plate width  (X)
lid_plate_y   = 50;    // plate depth  (Y)
lid_plate_z   = 2;     // plate thickness (Z)
lid_wall      = 1.5;   // lip wall thickness
lip_height    = 4;     // lip height above the plate
lip_outer_x   = 65.6;  // lip outer width  (X)
lip_outer_y   = 45.6;  // lip outer depth  (Y)

// ---------- Placement ----------
gap = 10;  // gap between the two parts

// Box occupies X in [-35, 35], Y in [-25, 25]
// Lid  occupies X in [ 45, 115], Y in [-25, 25]  (10 mm gap between them)
box_x0 = -box_outer_x / 2;
lid_x0 = box_outer_x / 2 + gap;

// ---------- Part 1: Box (open top, 2 mm walls, 2 mm floor) ----------
translate([box_x0, 0, 0]) {
    difference() {
        // outer solid
        cube([box_outer_x, box_outer_y, box_outer_z], center = [true, true, false]);
        // interior cavity (open at the top)
        translate([box_wall, box_wall, box_floor]) {
            cube([box_outer_x - 2 * box_wall,
                  box_outer_y - 2 * box_wall,
                  box_outer_z - box_floor + 1],   // +1 mm so the cut extends past the top face
                  center = [false, false, false]);
        }
    }
}

// ---------- Part 2: Lid (printed upside down: plate on bed, lip on top) ----------
translate([lid_x0, 0, 0]) {
    // plate lying on the bed
    cube([lid_plate_x, lid_plate_y, lid_plate_z], center = [true, true, false]);

    // rectangular lip on top of the plate, centred on the plate
    translate([0, 0, lid_plate_z]) {
        difference() {
            // outer lip block
            cube([lip_outer_x, lip_outer_y, lip_height], center = [true, true, false]);
            // hollow interior of the lip (cut extends 1 mm past the top face)
            translate([lid_wall, lid_wall, 0]) {
                cube([lip_outer_x - 2 * lid_wall,
                      lip_outer_y - 2 * lid_wall,
                      lip_height + 1],
                      center = [false, false, false]);
            }
        }
    }
}