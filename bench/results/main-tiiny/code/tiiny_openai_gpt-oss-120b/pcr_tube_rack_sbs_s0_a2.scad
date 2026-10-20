// 96‑tube rack – dimensions (mm)
X = 127.76;          // length along X
Y = 85.48;           // width  along Y
Z = 20;              // height up Z (resting on XY plane)

// Hole pattern
hole_d   = 6.2;      // tube hole diameter
spacing  = 9.0;      // centre‑to‑centre spacing
cols     = 12;       // columns (X direction)
rows     = 8;        // rows (Y direction)
offset_x = 14.38;    // distance from left edge to first hole centre
offset_y = 11.24;    // distance from back edge to first hole centre

// Chamfer (orientation mark) – 45° leg length
chamfer_leg = 5;     // leg length of the chamfer

// Extra amount to push cutting geometry beyond the part faces
extra = 0.5;         // 0.5 mm over‑extension

// Resolution for circles and arcs
$fn = 64;

// ------------------------------------------------
// Base block – placed with its left‑back bottom corner at the origin
module base_block() {
    // cube size X × Y × (Z+2·extra) so the top and bottom extend beyond the part faces
    translate([0, 0, -extra])
        cube([X, Y, Z + 2*extra], center = false);
}

// ------------------------------------------------
// Grid of through‑holes
module hole_grid() {
    for (i = [0 : cols-1], j = [0 : rows-1]) {
        // hole centre coordinates
        x = offset_x + i*spacing;
        y = offset_y + j*spacing;
        translate([x, y, -extra])
            cylinder(h = Z + 2*extra,
                     r = hole_d/2 + extra,
                     center = false);
    }
}

// ------------------------------------------------
// Chamfer cut at the left‑back corner (A1)
module chamfer_cut() {
    // right‑angled triangular prism extruded in Z
    linear_extrude(height = Z + 2*extra)
        polygon(points = [[0,0],
                          [chamfer_leg,0],
                          [0,chamfer_leg]]);
    // translate so the prism sits at the corner and extends below/above the block
    translate([0, 0, -extra])
        linear_extrude(height = Z + 2*extra)
            polygon(points = [[0,0],
                              [chamfer_leg,0],
                              [0,chamfer_leg]]);
}

// ------------------------------------------------
// Assemble the rack
difference() {
    base_block();
    union() {
        hole_grid();
        chamfer_cut();
    }
}