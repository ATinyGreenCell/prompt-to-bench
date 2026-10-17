// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), side by side, with a 10 mm gap.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness

lid_t      = 2;     // lid plate thickness
lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_over_x = (box_x - lip_x) / 2; // lip overhang on X (0.2 mm clearance side)
lip_over_y = (box_y - lip_y) / 2; // lip overhang on Y (0.2 mm clearance side)

gap        = 10;    // gap between the two parts

$fn = 64;

// ---------------- Model ----------------
union() {
    // Part 1: box (open top)
    translate([-box_x / 2, -box_y / 2, 0])
        cube([box_x, box_y, box_z - box_floor]);

    // Part 2: lid (printed upside down: plate + overhanging lip)
    translate([box_x / 2 + gap, -box_y / 2, 0])
        cube([box_y, t = lid_t, lip_x + 2 * lip_over_x]); // plate under the lip

    translate([box_x / 2 + gap - lip_over_x, -box_y / 2, lid_t])
        cube([lip_x + 2 * lip_over_x, lip_y + 2 * lip_over_y, lip_h]); // lip on top of the plate
}