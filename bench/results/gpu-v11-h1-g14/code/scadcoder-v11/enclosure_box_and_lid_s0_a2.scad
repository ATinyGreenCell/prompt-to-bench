// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts flat on the bed (XY plane), building up in +Z.
// The lid is printed upside down, so its lip faces upward and slides into the box opening.

// ---------------- Parameters ----------------
box_x        = 70;    // box outer size in X (mm)
box_y        = 50;    // box outer size in Y (mm)
box_z        = 30;    // box outer size in Z (mm)
box_wall     = 2;     // box wall thickness (mm)
box_floor    = 2;     // box floor thickness (mm)

lip_x        = 65.6;  // lip outer size in X (mm)
lip_y        = 45.6;  // lip outer size in Y (mm)
lip_t        = 1.5;   // lip wall thickness (mm)
lip_h        = 4;     // lip height above plate (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
gap          = 10;    // gap between box and lid on the bed (mm)

$fn = 64;

// ---------------- Derived ----------------
box_inner_x = box_x - 2 * box_wall;   // 66 mm
box_inner_y = box_y - 2 * box_wall;   // 46 mm
box_h       = box_z - box_floor;      // 28 mm (open top)

lip_x2      = lip_x - 2 * box_wall;   // 61.6 mm (inner opening in X)
lip_y2      = lip_y - 2 * box_wall;   // 41.6 mm (inner opening in Y)

// ---------------- Model ----------------
union() {
    // Part 1: Box, centred in X and Y, sitting on z = 0
    translate([-box_x / 2, -box_y / 2, 0])
        cube([box_x, box_y, box_h]);

    // Part 2: Lid plate with a rectangular lip on top, centred on the plate
    translate([box_x / 2 + gap, -box_y / 2, 0])
        union() {
            // Base plate, 2 mm thick
            cube([lip_x, lip_y, 2]);

            // Lip: 1.5 mm wall, 4 mm tall, outer size 65.6 x 45.6 mm
            // (overlaps the plate slightly so the union is one solid)
            translate([0, 0, -0.01])
                cube([lip_x, lip_y, lip_h + 0.01]);
        }
}