// Two-part enclosure for small electronics board
// Print orientation: both parts on the bed, lid on +X side of box

// ---- Box ----
box_x = 70;      // outer size in X
box_y = 50;      // outer size in Y
box_z = 30;      // outer size in Z
wall = 2;        // wall thickness
floor = 2;       // floor thickness

// ---- Lid ----
lip_w = 65.6;    // lip outer size in X
lip_y = 45.6;    // lip outer size in Y
lip_t = 1.5;     // lip thickness
lip_h = 4;       // lip height
eps = 0.2;       // clearance between lip and box opening

// Derived
lip_b = lip_w - 2 * eps;   // lip inner size in X
lip_d = lip_y - 2 * eps;   // lip inner size in Y

$fn = 64;

// Print gap
gap = 10;

module box() {
    difference() {
        cube([box_x, box_y, box_z]);
        translate([wall, wall, floor])
            cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor]);
    }
}

module lid() {
    translate([-lip_w / 2, -lip_y / 2, 0])
        union() {
            // Base plate
            cube([lip_w, lip_y, wall]);
            // Lip (printed upside down, overhangs plate)
            cube([lip_b, lip_d, lip_h]);
        }
}

box();
translate([0, 0, gap])
    lid();