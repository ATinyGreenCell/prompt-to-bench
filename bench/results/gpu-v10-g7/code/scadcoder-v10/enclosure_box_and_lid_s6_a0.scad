// Two-part enclosure for small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box upright, lid upside down on the bed, 10 mm gap between them

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X (mm)
box_y      = 50;    // box outer size in Y (mm)
box_z      = 30;    // box outer size in Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

lid_plate_x      = 70;    // lid plate size in X (mm)
lid_plate_y      = 50;    // lid plate size in Y (mm)
lid_plate_t      = 2;     // lid plate thickness (mm)

lip_outer_x      = 65.6;  // lip outer size in X (mm)
lip_outer_y      = 45.6;  // lip outer size in Y (mm)
lip_t            = 1.5;   // lip thickness (mm)
lip_height       = 4;     // lip height above plate (mm)

clearance        = 0.2;   // clearance between lip inner size and box opening (mm)
gap              = 10;    // gap between box and lid (mm)
eps              = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// Derived
lip_inner_x = lip_outer_x - 2 * clearance;   // 65.2 mm
lip_inner_y = lip_outer_y - 2 * clearance;   // 45.2 mm

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    translate([-box_x / 2, -box_y / 2, 0])
        difference() {
            cube([box_x, box_y, box_z]);
            translate([0, 0, box_floor])
                cube([box_x, box_y, box_z - box_floor + eps]);   // open-top cut
        }

    // Part 2: Lid (plate with lip), printed upside down
    translate([gap, 0, 0])
        union() {
            // Plate lying on the bed
            translate([-lid_plate_x / 2, -lid_plate_y / 2, 0])
                cube([lid_plate_x, lid_plate_y, lid_plate_t]);

            // Lip on top of the plate (extends above it)
            translate([-lip_outer_x / 2, -lip_outer_y / 2, lid_plate_t])
                cube([lip_outer_x, lip_outer_y, lip_t]);
        }
}