// Two-part enclosure for small electronics board
// Print orientation: both parts flat on bed, lid on +X side of box

// ---- Box ----
box_x = 70;      // outer length (X)
box_y = 50;      // outer width (Y)
box_z = 30;      // outer height (Z)
wall = 2;        // side wall thickness
floor = 2;       // floor thickness

// ---- Lid ----
lip_w = 65.6;    // lip outer length (X)
lip_d = 45.6;    // lip outer width (Y)
lip_h = 4;       // lip height (wall thickness)
eps = 0.2;       // clearance between lip and box opening

// ---- Misc ----
gap = 10;        // gap between parts on bed
overlap = 0.01;  // small overlap so lid sits in box in union

$fn = 64;

difference() {
    union() {
        // Box (open top)
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z - wall]);
        // Lid (printed upside down, resting on bed)
        translate([box_x/2 + gap, -box_y/2, 0])
            cube([lip_w, lip_d, lip_h]);
    }
    // Cut the open-top cavity
    translate([-box_x/2 + wall, -box_y/2 + wall, floor])
        cube([box_x - 2*wall, box_y - 2*wall, box_z - wall + overlap]);
}