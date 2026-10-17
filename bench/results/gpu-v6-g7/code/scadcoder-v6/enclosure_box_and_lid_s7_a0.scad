// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box stands on the bed, lid is printed upside down on the +X side.

$fn = 64;

// ---- Box (Part 1) ----
box_x      = 70;    // outer length (X)
box_y      = 50;    // outer width (Y)
box_z      = 30;    // outer height (Z)
wall       = 2;     // wall thickness
floor      = 2;     // floor thickness under the open top

// ---- Lid (Part 2) ----
lip_outer_x = 65.6; // outer size of the sliding lip (X)
lip_outer_y = 45.6; // outer size of the sliding lip (Y)
lip_h       = 4;    // lip height above the plate
lip_w       = 1.5;  // lip wall thickness
eps         = 0.2;  // clearance between lip inner size and box opening

// ---- Layout ----
gap        = 10;    // gap between the two parts on the bed

plate_t     = 2;    // lid plate thickness (resting on the bed)

// Derived
box_inner_x = box_x - 2 * wall;
box_inner_y = box_y - 2 * wall;
lip_in_x    = lip_outer_x - 2 * lip_w;
lip_in_y    = lip_outer_y - 2 * lip_w;

module box() {
    difference() {
        cube([box_x, box_y, box_z - floor]);
        translate([wall, wall, floor])
            cube([box_inner_x, box_inner_y, box_z - floor + 1]); // open-top cavity
    }
}

module lid() {
    union() {
        // Plate lying on the bed
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, plate_t]);
        // Lip on top of the plate, centred, extending into the box opening
        translate([-lip_outer_x / 2, -lip_outer_y / 2, plate_t])
            cube([lip_outer_x, lip_outer_y, lip_h]);
    }
}

module part(p) {
    translate([p == 1 ? -box_x / 2 : box_x / 2 + gap,
               -box_y / 2, 0])
        p == 1 ? box() : lid();
}

for (p = [1, 2])
    part(p);