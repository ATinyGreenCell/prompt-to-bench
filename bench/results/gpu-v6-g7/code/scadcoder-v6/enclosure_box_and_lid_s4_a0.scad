// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box stands on the bed, lid lies flat on the bed upside down.
// The two parts are placed side by side with a 10 mm gap so they print together.

$fn = 64;

// ---------------- Dimensions (mm) ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness (sides and floor)

gap        = 10;    // gap between box and lid along X

plate_x    = 70;    // lid plate length (X)
plate_y    = 50;    // lid plate width (Y)
plate_t    = 2;     // lid plate thickness (Z)

lip_h      = 4;     // lid lip height (Z)
lip_w      = 65.6;  // lid lip outer length (X)
lip_d      = 45.6;  // lid lip outer width (Y)
clearance  = 0.2;   // clearance between lip outer size and box opening

eps        = 0.5;   // overcut for clean boolean differences

// Derived
box_inner_x = box_x - 2 * wall;   // 66
box_inner_y = box_y - 2 * wall;   // 46
box_opening = [box_inner_x, box_inner_y];  // opening size (X x Y)

// Lip check: 65.6 + 2*0.2 = 66.0 -> 1.0 mm clearance on each side
assert(abs(lip_w + 2 * clearance - box_inner_x) < 0.001, "Lip length clearance mismatch");
assert(abs(lip_d + 2 * clearance - box_inner_y) < 0.001, "Lip width clearance mismatch");

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    translate([-box_x / 2, -box_y / 2, 0])
        difference() {
            cube([box_x, box_y, box_z]);
            translate([wall, wall, box_z - eps])
                cube([box_inner_x, box_inner_y, eps]);  // open-top cut
        }

    // Part 2: Lid (printed upside down)
    translate([(box_x - plate_x) / 2, -plate_y / 2, 0])
        difference() {
            // Base plate
            cube([plate_x, plate_y, plate_t]);
            // Lip: wall on top of the plate, extending toward +Z
            translate([(plate_x - lip_w) / 2, (plate_y - lip_d) / 2, plate_t])
                cube([lip_w, lip_d, lip_h]);
            // Cut the lip so it slides into the box opening with clearance
            translate([wall - eps, wall - eps, plate_t])
                cube([box_opening[0] + 2 * eps, box_opening[1] + 2 * eps, lip_h + eps]);
        }
}