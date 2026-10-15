// Pillow block - a bench block that supports a horizontal shaft through a bore, bolted down
// at each end. NOVEL general mechanical mount.
//
// @desc pillow block that supports a horizontal shaft through a bore
// @prompt Design a pillow block in OpenSCAD: a block {bw} mm wide and {bl} mm deep carrying a horizontal {bore} mm bore at mid height, with a {bolt} mm bolt hole near each end to fix it to a surface. Reply with a single complete OpenSCAD file.
// @param bore  shaft bore diameter, mm   [6:24]
// @param bw    block width, mm           [40:90]
// @param bl    block depth, mm           [18:50]
// @param bolt  bolt hole diameter, mm    [3:8]

bore = 12;
bw   = 50;
bl   = 24;
bolt = 5;

$fn = 72;

H = bore + 16;                 // height so the bore has wall above and below

difference() {
    translate([-bw / 2, -bl / 2, 0]) cube([bw, bl, H]);
    translate([0, -bl / 2 - 1, H / 2]) rotate([-90, 0, 0]) cylinder(h = bl + 2, d = bore);   // horizontal bore
    for (x = [-bw * 0.38, bw * 0.38])
        translate([x, 0, -1]) cylinder(h = H + 2, d = bolt);                                 // bolt holes
}
