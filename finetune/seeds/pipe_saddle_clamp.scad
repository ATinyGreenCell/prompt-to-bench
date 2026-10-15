// Pipe saddle clamp - a block with a semicircular groove that cradles a round pipe or
// rod against a flat surface, with a bolt hole each side to screw it down. NOVEL part.
//
// @desc pipe saddle clamp that fixes a round pipe or rod to a flat surface
// @prompt Design a pipe saddle clamp in OpenSCAD: a block with a semicircular groove that cradles a {pipe_d} mm diameter pipe against a surface, with a {bolt_d} mm bolt hole on each side to screw it down. Reply with a single complete OpenSCAD file.
// @param pipe_d  pipe outer diameter, mm            [8:50]
// @param bolt_d  bolt hole diameter, mm             [3:8]
// @param base_t  floor thickness under the groove, mm   [3:8]

pipe_d = 20;
bolt_d = 4;
base_t = 4;

$fn = 72;

sr     = pipe_d / 2 + 0.5;          // groove radius, with a little clearance
L      = 16;                        // length along the pipe axis
margin = bolt_d + 4;
w      = pipe_d + 2 * margin;       // overall width
h      = base_t + sr;               // block height so the groove centre sits at the top

difference() {
    translate([-w / 2, -L / 2, 0]) cube([w, L, h]);
    translate([0, -L / 2 - 1, h]) rotate([-90, 0, 0]) cylinder(h = L + 2, r = sr);   // groove
    for (x = [-(pipe_d / 2 + margin / 2), pipe_d / 2 + margin / 2])
        translate([x, 0, -1]) cylinder(h = h + 2, d = bolt_d);                        // bolt holes
}
