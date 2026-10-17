// Buffer tank for a mini horizontal gel-electrophoresis box. Open-top rectangular tank with a
// solid raised platform for the gel tray in the middle, dividing the bottom into two buffer
// chambers. Each end wall gets a horizontal 2 mm hole along X at y = 0, z = 30 for the
// electrode wires. NOVEL general part.
//

tank_L = 120;
tank_W = 70;
tank_H = 40;
wall   = 3;
floor  = 3;
plat_L = 60;
plat_H = 10;

$fn = 64;

inner_L = tank_L - 2 * wall;
inner_W = tank_W - 2 * wall;
inner_H = tank_H - floor;

difference() {
    cube([tank_L, tank_W, tank_H]);
    translate([wall, wall, floor]) cube([inner_L, inner_W, inner_H]);     // hollow, open top
    translate([wall, 0, floor]) cube([plat_L, tank_W, plat_H]);           // raised platform (Y spans full width)
    for (x = [-tank_L / 2, tank_L / 2])
        translate([x, 0, tank_H - inner_H]) rotate([-90, 0, 0]) cylinder(h = tank_L, d = 2);  // horizontal hole through each end wall along X at y = 0, z = 30
}