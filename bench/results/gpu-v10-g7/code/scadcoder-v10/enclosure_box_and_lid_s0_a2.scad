// Two-part enclosure for small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box standing on bed, lid plate flat on bed, lip pointing up (+Z)
// Units: mm

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness (sides and floor)

lip_t      = 1.5;   // lid lip thickness (X direction)
lip_h      = 4;     // lid lip height (Z)
lip_o_x    = 65.6;  // lid lip outer length (X)
lip_o_y    = 45.6;  // lid lip outer width (Y)

eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Derived ----------------
box_inner_x = box_x - 2 * box_wall;   // 66
box_inner_y = box_y - 2 * box_wall;   // 46
box_floor_t = box_wall;               // 2

lip_mag_x   = lip_o_x + 2 * lip_t;     // 68.6
lip_mag_y   = lip_o_y + 2 * lip_t;     // 49.6

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    translate([-box_x / 2, -box_y / 2, 0])
        difference() {
            cube([box_x, box_y, box_z]);
            translate([-box_inner_x / 2, -box_inner_y / 2, box_floor_t])
                cube([box_inner_x, box_inner_y, box_z - box_floor_t + eps]); // open-top cavity
        }

    // Part 2: Lid (plate + rectangular lip), centred on origin in XY, placed on +X side of box
    translate([0, 0, 0])
        union() {
            // Base plate, 70 x 50, lying on the bed
            translate([-box_x / 2, -box_y / 2, 0])
                cube([box_x, box_y, 2]);

            // Lip: wall of thickness lip_t, height lip_h, outer size lip_o_x x lip_o_y
            translate([-lip_o_x / 2, -lip_o_y / 2, 2])
                cube([lip_o_x, lip_o_y, lip_h]);
        }
}