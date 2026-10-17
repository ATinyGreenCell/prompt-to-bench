// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), side by side, with a 10 mm gap.
// Units: mm. Wall thicknesses are 2 mm (box) and 1.5 mm (lip).

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height (from plate top)
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
clearance  = 0.2;   // clearance between lip and box opening on each side

eps        = 0.5;   // cutter overshoot past faces
$fn        = 64;

// Derived: plate thickness under the lip
plate_t    = lip_t; // 1.5 mm (plate and lip are one solid, printed upside down)

// ---------------- Modules ----------------
module box() {
    // Open-top box: walls + floor, no top face
    difference() {
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z]);
        // Cut out the open top (through the top face)
        translate([-box_x/2, -box_y/2, box_z - eps])
            cube([box_x, box_y, eps + 1]);
    }
}

module lid() {
    // Plate with centred rectangular lip. Printed upside down:
    // the lip is the top face of the solid, so it slides into the box opening.
    union() {
        // Base plate
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, plate_t]);
        // Lip (overlaps the plate by lip_t, so they fuse into one solid)
        translate([-lip_x/2, -lip_y/2, plate_t])
            cube([lip_x, lip_y, lip_h + eps]);
    }
}

// ---------------- Assembly ----------------
// Print the two parts side by side on the bed, 10 mm apart
difference() {
    union() {
        box();
        translate([box_x + 10, 0, 0])
            lid();
    }
    // A small invisible cutter removes the 10 mm gap region from the union,
    // so the two parts remain distinct solids in one file.
    translate([box_x + 5, -box_y - 1, 0])
        cube([20, box_y + 2, box_z + 1]);
}