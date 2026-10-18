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
gap = 10;        // gap between parts

$fn = 64;

difference() {
    union() {
        // Box (open top)
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z - floor]);
        // Lid (plate + lip, printed upside down)
        translate([box_x/2 + gap, -box_y/2, 0])
            cube([lip_w, lip_d, lip_t]);
        translate([box_x/2 + gap - lip_w/2, -lip_d/2, lip_t])
            cube([lip_w, lip_d, lip_h]);
    }
    // Cut out the box interior (open top)
    translate([-box_x/2 - eps, -box_y/2 - eps, floor])
        cube([box_x + 2*eps, box_y + 2*eps, box_z - floor + 0.01]);
}