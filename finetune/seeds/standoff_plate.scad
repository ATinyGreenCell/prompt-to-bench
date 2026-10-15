// PCB standoff plate - a base plate with four standoff bosses at a square pitch, each with a
// screw hole, to mount a board above a surface. NOVEL general part.
//
// @desc PCB standoff plate with four standoff bosses
// @prompt Design a PCB standoff plate in OpenSCAD: a {plate} mm square base with four standoff bosses {boss_h} mm tall at the corners of a {pitch} mm square, each with a {screw} mm screw hole. Reply with a single complete OpenSCAD file.
// @param plate  plate size (square), mm   [40:150]
// @param pitch  mounting hole pitch, mm   [25:120]
// @param boss_h standoff height, mm       [4:20]
// @param screw  screw hole diameter, mm   [2:6]

plate  = 70;
pitch  = 50;
boss_h = 8;
screw  = 3;

$fn = 48;

base_t = 3;
boss_d = screw + 5;

difference() {
    union() {
        translate([-plate / 2, -plate / 2, 0]) cube([plate, plate, base_t]);
        for (x = [-pitch / 2, pitch / 2])
            for (y = [-pitch / 2, pitch / 2])
                translate([x, y, 0]) cylinder(h = base_t + boss_h, d = boss_d);
    }
    for (x = [-pitch / 2, pitch / 2])
        for (y = [-pitch / 2, pitch / 2])
            translate([x, y, -1]) cylinder(h = base_t + boss_h + 2, d = screw);
}
