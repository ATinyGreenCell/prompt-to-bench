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
gap = 10;        // gap between box and lid on bed
lip_t = 0.01;    // small overlap so lip fuses with plate

$fn = 64;

difference() {
    union() {
        // Box: open top, solid floor and walls
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z - floor]);
    }

    // Lid: plate + lip, printed upside down (lip on top)
    translate([box_x/2 + gap, -50/2, 0])
        linear_extrude(lip_d)
            polygon([[-lip_w/2, -lip_w/2], [lip_w/2, -lip_w/2],
                     [lip_w/2, lip_w/2], [-lip_w/2, lip_w/2]]);
}