// Two-part enclosure for a small electronics board (e.g. Arduino-based logger)
// Print orientation: both parts flat on the bed, side by side.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
eps        = 0.5;   // cutter overshoot past faces

lip_t      = 1.5;   // lid lip thickness
lip_h      = 4;     // lid lip height (top of lip above plate)
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_over   = 2.5;   // lip overhang past plate on each side (1.5 + 1.0 clearance)

gap        = 10;    // horizontal gap between box and lid
$fn        = 64;

// ---------------- Model ----------------
union() {
    // Part 1: open-top box
    translate([-box_x/2, -box_y/2, 0])
        difference() {
            cube([box_x, box_y, floor + wall + box_z - wall]);
            translate([0, 0, floor + wall])
                cube([box_x - 2*wall, box_y - 2*wall, box_z - wall]);
        }

    // Part 2: lid (printed upside down; plate on bed, lip pointing down)
    translate([box_x/2 + gap, -lip_y/2, 0])
        union() {
            // base plate
            translate([0, 0, 0])
                rectangle([lip_x, lip_y], thickness = 2);
            // lip, extended past the plate so the union is clean
            translate([0, 0, 0])
                linear_extrude(height = lip_h + 1)
                    rectangle([lip_x - 2*lip_over, lip_y - 2*lip_over], thickness = lip_t);
        }
}