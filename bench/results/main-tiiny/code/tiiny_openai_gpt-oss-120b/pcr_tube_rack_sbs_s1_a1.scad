// 96‑tube PCR rack – dimensions (mm)
X = 127.76;          // block length (X)
Y = 85.48;           // block width  (Y)
Z = 20;              // block height (Z)

hole_d = 6.2;        // tube hole diameter
hole_r = hole_d/2;   // tube hole radius

spacing = 9.0;       // centre‑to‑centre spacing of holes
rows   = 8;          // number of rows (along Y)
cols   = 12;         // number of columns (along X)

offsetX = 14.38;     // X distance from left edge to first hole centre
offsetY = 11.24;     // Y distance from back edge to first hole centre

chamfer_leg = 5;    // length of 45° chamfer legs
extra = 1;          // over‑cut amount (mm) beyond block faces

$fn = 64;           // resolution for circles and extrusions

// ---------- Main block (resting on XY plane, centred on origin) ----------
module base_block() {
    translate([-X/2, -Y/2, 0])
        cube([X, Y, Z]);
}

// ---------- Tube holes (through‑holes) ----------
module tube_holes() {
    for (col = [0:cols-1], row = [0:rows-1]) {
        x = -X/2 + offsetX + col*spacing;
        y = -Y/2 + offsetY + row*spacing;
        translate([x, y, -extra])
            cylinder(r = hole_r, h = Z + 2*extra, center = false);
    }
}

// ---------- 45° chamfer at the A1 corner ----------
module chamfer_cut() {
    // right‑triangle prism (0,0)-(chamfer_leg,0)-(0,chamfer_leg) extruded
    translate([-X/2, -Y/2, -extra])
        linear_extrude(height = Z + 2*extra)
            polygon(points = [[0,0], [chamfer_leg,0], [0,chamfer_leg]]);
}

// ---------- Final part ----------
difference() {
    base_block();
    tube_holes();
    chamfer_cut();
}