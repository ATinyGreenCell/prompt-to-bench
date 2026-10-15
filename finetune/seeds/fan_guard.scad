// Fan guard / grill - an outer ring, a central hub and radial spokes. NOVEL general part.
//
// @desc fan guard / grill - a ring with a hub and radial spokes
// @prompt Design a fan guard in OpenSCAD: a {od} mm outer ring with a central hub {hub_d} mm across and {spokes} radial spokes, {t} mm thick. Reply with a single complete OpenSCAD file.
// @param od     outer diameter, mm   [40:140]
// @param spokes number of spokes     [4:10:1]
// @param t      thickness, mm        [2:5]
// @param hub_d  hub diameter, mm     [8:25]

od     = 80;
spokes = 6;
t      = 3;
hub_d  = 16;

$fn = 96;

ring_w = 4;

union() {
    difference() {
        cylinder(h = t, d = od);
        translate([0, 0, -1]) cylinder(h = t + 2, d = od - 2 * ring_w);
    }
    cylinder(h = t, d = hub_d);
    for (i = [0 : spokes - 1])
        rotate([0, 0, i * 360 / spokes]) translate([0, -1.5, 0]) cube([od / 2, 3, t]);
}
