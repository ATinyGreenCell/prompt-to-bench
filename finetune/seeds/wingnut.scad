// Wing nut - a finger-tightened nut blank: a central hub with a bore and two flat wings.
// (A bore, not a modelled thread - tap it or use it as a thumb spacer.) NOVEL general part.
//
// @desc wing nut - a finger-tightened nut blank with two wings and a bore
// @prompt Design a wing nut in OpenSCAD: a central hub {hub_d} mm across and {height} mm tall with a {bore} mm bore, and two flat wings extending {wing} mm so it can be turned by hand. Reply with a single complete OpenSCAD file.
// @param hub_d  hub diameter, mm    [10:30]
// @param height height, mm          [6:20]
// @param bore   bore diameter, mm    [3:16]
// @param wing   wing length, mm      [10:35]

hub_d  = 16;
height = 10;
bore   = 6;
wing   = 20;

$fn = 64;

wing_t = 3;
wing_h = height * 0.8;

difference() {
    union() {
        cylinder(h = height, d = hub_d);
        for (a = [0, 180])
            rotate([0, 0, a]) translate([hub_d / 2 - 1, -wing_t / 2, 0]) cube([wing, wing_t, wing_h]);
    }
    translate([0, 0, -1]) cylinder(h = height + 2, d = bore);
}
