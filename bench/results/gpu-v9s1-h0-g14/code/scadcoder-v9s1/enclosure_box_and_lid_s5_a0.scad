// Two-part enclosure for small electronics board
// Print orientation: box standing on bed, lid upside down (plate on bed)

$fn = 64;

// ---- Box ----
box_x = 70;      // outer length (X)
box_y = 50;      // outer width (Y)
box_z = 30;      // outer height (Z)
wall = 2;        // wall thickness
floor = 2;       // floor thickness

// ---- Lid ----
lip_w = 65.6;    // lip outer length (X)
lip_d = 45.6;    // lip outer width (Y)
lip_h = 4;       // lip height (wall above plate)
plate_t = 2;     // plate thickness
clearance = 0.2; // gap between lip outer and box inner (each side)

// ---- Layout ----
gap = 10;        // gap between box and lid on bed
lip_overlap = wall + clearance; // lip extends into box opening

module box() {
    difference() {
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z]);
        // open top: cut down to floor height
        translate([-box_x/2 - 1, -box_y/2 - 1, floor])
            cube([box_x + 2, box_y + 2, box_z - floor + 1]);
    }
}

module lid() {
    union() {
        // plate
        translate([-lip_w/2, -lip_d/2, 0])
            cube([lip_w, lip_d, plate_t]);
        // lip
        translate([-lip_w/2, -lip_d/2, plate_t])
            cube([lip_w, lip_d, lip_h]);
    }
}

box();
translate([0, gap, 0]) lid();