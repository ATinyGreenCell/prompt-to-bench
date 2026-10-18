// Two-part enclosure for small electronics board
// Print orientation: box upright, lid upside down (flat on bed)

// ---------- Parameters ----------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
lip_t      = 1.5;   // lid lip thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
eps        = 0.5;   // cutter overshoot past faces
gap        = 10;    // gap between box and lid

$fn = 64;

// ---------- Model ----------
union() {
    // Box
    translate([-box_x/2, -box_y/2, 0])
        difference() {
            cube([box_x, box_y, box_z + floor]);
            translate([0, 0, floor])
                cube([box_x - 2*wall, box_y - 2*wall, box_z + floor - wall]);
        }

    // Lid (printed upside down: plate on bed, lip pointing down into box)
    translate([gap - lip_x/2, -lip_y/2, 0])
        difference() {
            // Plate
            translate([0, 0, -lip_t])
                cube([lip_x, lip_y, lip_t + eps]);
            // Lip (extends below the plate by lip_h, slides into box opening)
            translate([0, 0, -lip_t - lip_h])
                cube([lip_x, lip_y, lip_h + eps]);
        }
}