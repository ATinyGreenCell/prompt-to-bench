// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts flat on the bed (XY plane), building up in +Z
// Print side by side along X with a 10 mm gap between them

// ---------------- Parameters ----------------
box_x            = 70;    // box outer size in X (mm)
box_y            = 50;    // box outer size in Y (mm)
box_z            = 30;    // box outer size in Z (mm)
box_wall         = 2;     // box wall thickness (mm)
box_floor        = 2;     // box floor thickness (mm)

lid_x            = 70;    // lid plate size in X (mm)
lid_y            = 50;    // lid plate size in Y (mm)
lid_wall         = 1.5;   // lid lip wall thickness (mm)
lid_lip_height   = 4;     // lid lip height above plate (mm)
lip_outer_x      = 65.6;  // outer size of lip in X (mm)
lip_outer_y      = 45.6;  // outer size of lip in Y (mm)
lip_clearance    = 0.2;   // clearance between lip inner/outer edges (mm)

gap              = 10;    // gap between box and lid on the bed (mm)

eps              = 0.5;   // overcut for clean boolean differences (mm)

// Derived values
box_inner_x      = box_x - 2*box_wall;   // 66 mm
box_inner_y      = box_y - 2*box_wall;   // 46 mm
box_open_top_z   = box_z - box_wall;     // top of walls (open)
lip_inner_x      = lip_outer_x - 2*lip_clearance; // 65.2 mm
lip_inner_y      = lip_outer_y - 2*lip_clearance; // 45.2 mm
plate_t          = 2;                    // lid plate thickness (mm)

// ---------------- Model ----------------
union() {
    // Part 1: Box, open top
    translate([-box_x/2, -box_y/2, 0])
        difference() {
            cube([box_x, box_y, box_open_top_z + box_wall]);
            translate([-box_inner_x/2, -box_inner_y/2, box_floor])
                cube([box_inner_x, box_inner_y, box_open_top_z]);
        }

    // Part 2: Lid, printed upside down (lip on top, plate below)
    translate([(box_x + gap)/2, -lid_y/2, 0])
        union() {
            // Base plate
            translate([-lid_x/2, -lid_y/2, 0])
                cube([lid_x, lid_y, plate_t]);

            // Rectangular lip on top of the plate
            translate([-lip_inner_x/2, -lip_inner_y/2, plate_t])
                cube([lip_inner_x, lip_inner_y, lid_lip_height]);
        }
}