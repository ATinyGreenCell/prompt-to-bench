// Two-part enclosure for small electronics board
// Print orientation: both parts on the bed, lid on +X side of box

// ---- Box ----
box_x = 70;      // outer length (X)
box_y = 50;      // outer width (Y)
box_z = 30;      // outer height (Z)
wall = 2;        // wall thickness
floor = 2;       // floor thickness

// ---- Lid ----
lip_w = 65.6;    // lip outer length (X)
lip_d = 45.6;    // lip outer width (Y)
lip_h = 4;       // lip height (Z)
lip_t = 1.5;     // lip wall thickness

// ---- Misc ----
eps = 0.5;       // cutter overshoot
gap = 10;        // gap between parts on bed
$fn = 64;

// Derived
inner_x = box_x - 2*wall;
inner_y = box_y - 2*wall;
lip_f  = lip_w - inner_x + 0.4;  // clearance 0.2 each side
lip_b  = lip_d - inner_y + 0.4;

module box() {
    difference() {
        cube([box_x, box_y, box_z]);
        translate([wall, wall, floor])
            cube([inner_x, inner_y, box_z - floor]);   // open top
    }
}

module lid() {
    translate([gap, 0, 0])
        union() {
            // plate
            translate([0, 0, -1])
                cube([lip_w, lip_d, 2]);
            // lip (overlaps plate -> fuses)
            translate([-lip_f/2, -lip_b/2, 0])
                cube([lip_w, lip_d, lip_h]);
        }
}

box();
translate([0, box_y + 10, 0])
    lid();