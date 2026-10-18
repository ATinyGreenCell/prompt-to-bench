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
lip_h = 4;       // lip height (wall thickness)
eps = 0.2;       // clearance between lip and box opening

// ---- Layout ----
gap = 10;        // gap between box and lid on the bed
overlap = 0.01;  // small overlap so lid and lip fuse cleanly

$fn = 64;

difference() {
    union() {
        // Box: open top, solid floor and walls
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z - floor]);
    }

    // Lid: plate on the bed, with a rectangular lip on top of it
    translate([box_x/2 + gap - lip_w/2, -lip_d/2, 0])
        linear_extrude(lip_d)
            polygon([
                [0, 0],
                [lip_w, 0],
                [lip_w, overlap],
                [0, overlap]
            ]);
}