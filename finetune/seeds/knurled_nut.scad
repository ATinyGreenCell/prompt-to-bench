// Knurled thumb nut - a cylinder with grip grooves around the rim and a bore. NOVEL part.
//
// @desc knurled thumb nut with a bore
// @prompt Design a knurled thumb nut in OpenSCAD: a cylinder {od} mm across and {height} mm tall with a {bore} mm bore and {knurls} grip grooves around the rim. Reply with a single complete OpenSCAD file.
// @param od     outer diameter, mm   [12:40]
// @param height height, mm           [5:20]
// @param bore   bore diameter, mm    [3:20]
// @param knurls number of grooves    [12:40:1]

od     = 20;
height = 10;
bore   = 6;
knurls = 24;

$fn = 64;

difference() {
    cylinder(h = height, d = od);
    translate([0, 0, -1]) cylinder(h = height + 2, d = bore);
    for (i = [0 : knurls - 1])
        rotate([0, 0, i * 360 / knurls]) translate([od / 2, 0, -1]) cylinder(h = height + 2, d = od * 0.08);
}
