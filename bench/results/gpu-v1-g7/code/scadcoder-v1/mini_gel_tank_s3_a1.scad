// Open-top rectangular buffer tank for a mini horizontal gel-electrophoresis box. NOVEL general part.
//

inner_l = 120;
inner_w = 70;
height  = 40;
wall    = 3;
floor   = 3;

$fn = 48;

inner_h = height - floor;

difference() {
    cube([inner_l + 2 * wall, inner_w, height]);
    translate([0, 0, floor]) cube([inner_l + 2 * wall, inner_w, height - floor]);   // hollow, open top
    translate([0, inner_w / 2 - 1.5, floor]) cube([60, inner_w, height - floor + 10]);      // raised platform (spans full width)
    for (y = [-1, 1])
        translate([0, inner_w / 2, -1]) rotate([-90, 0, 0]) cylinder(h = height + 2, d = 2);   // electrode holes, horizontal along X, at y = +/- wall (centre of the wall thickness)
}