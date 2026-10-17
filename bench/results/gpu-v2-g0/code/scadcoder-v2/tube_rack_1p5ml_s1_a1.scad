// Bench rack for 1.5 mL microcentrifuge tubes - a solid rectangular block with a regular
// grid of vertical tube holes, open at the top and closed at the bottom (a "floor" below
// the lowest hole). NOVEL general part (a generic hole grid, not tied to one tool).
//

len   = 106;
wid   = 72;
ht    = 30;
rows  = 4;
cols  = 6;
pX    = 16;
pY    = 16;
dHole = 11.2;
dDeep = 25;

$fn = 48;

floor = ht - dDeep;

difference() {
    translate([-len / 2, -wid / 2, 0]) cube([len, wid, ht]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([
            -len / 2 + pX / 2 + i * pX,
            -wid / 2 + pY / 2 + j * pY,
            -1
        ]) cylinder(h = dDeep + 2, d = dHole);
}