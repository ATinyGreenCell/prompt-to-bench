// Two-part enclosure for small electronics board
// Print orientation: box standing on bed, lid upside down (plate on bed)

$fn = 64;

// ---- Box ----
box_x = 70;      // outer length (X)
box_y = 50;      // outer width (Y)
box_z = 30;      // outer height (Z)
wall = 2;        // side wall thickness
floor = 2;       // floor thickness

// ---- Lid ----
lip_w = 65.6;    // lip outer length (X)
lip_d = 45.6;    // lip outer width (Y)
lip_h = 1.5;     // lip height (wall thickness)
lip_t = 4;       // lip top thickness

// ---- Misc ----
eps = 0.5;       // cutter overshoot
gap = 10;        // gap between parts on bed

// Derived
inner_x = box_x - 2*wall;
inner_y = box_y - 2*wall;
lip_total_h = lip_h + lip_t;   // from plate top to lip top

module box() {
    difference() {
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z]);
        // open top: cut down to inside of side walls
        translate([-inner_x/2, -inner_y/2, floor])
            cube([inner_x, inner_y, floor + wall + eps]);
    }
}

module lid() {
    translate([gap - lip_w/2, -lip_d/2, 0]) {
        // plate
        cube([lip_w, lip_d, 2]);
        // lip (overlaps plate slightly -> one solid)
        translate([-lip_w/2, -lip_d/2, 2 - eps])
            cube([lip_w, lip_d, lip_total_h + eps]);
    }
}

union() {
    box();
    translate([0, 0, box_z])
        lid();
}