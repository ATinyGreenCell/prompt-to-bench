// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box upright, lid upside-down (plated side down) so they fuse together.
// Units: mm

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_h      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
lip_t      = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height (from plate top)
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)
clearance  = 0.2;   // side clearance between lip and box opening
gap        = 10;    // horizontal gap between box and lid on the bed
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// Derived: lid plate thickness = lip_t + 0.01 (plate fuses into the lip wall)
lid_plt_t = lip_t + 0.01;

// ---------------- Model ----------------
difference() {
    union() {
        // Part 1: Box (open top)
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_h - floor]);   // floor included in height

        // Part 2: Lid (upside-down: plate with a lip that overhangs the plate)
        translate([box_x/2 + gap, -lip_y/2, 0])
            cube([lip_x, lip_y, lid_plt_t]);       // base plate
        translate([box_x/2 + gap, -lip_y/2, lid_plt_t])
            cube([lip_x, lip_y, lip_h]);           // lip standing on the plate
    }

    // Cut the lip's cavity so it slides into the box opening with the set clearance
    translate([box_x/2 + gap - clearance, -lip_y/2 - clearance, lid_plt_t])
        cube([lip_x + 2*clearance, lip_y + 2*clearance, lip_h + eps]);
}