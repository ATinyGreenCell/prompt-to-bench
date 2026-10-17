// Fan box - an open box (top open) housing for a round PC case fan, e.g. an 80 mm fan. NOVEL part.
//

top    = 90;
height = 40;
wall   = 2.5;
screw  = 4.5;

$fn = 48;

inner = top - 2 * wall;

difference() {
    cube([top, top, height + wall]);                 // outer block, floor included
    translate([wall, wall, wall]) cube([inner, inner, height]);   // hollow: open top at z = height + wall
    for (sx = [-1, 1]) for (sy = [-1, 1])
        translate([sx * 0.5 * (top - 2 * wall), sy * 0.5 * (top - 2 * wall), 0])
            cylinder(h = height + 1, d = screw);                 // screw holes through the floor
    // one cable notch in a wall: 12 mm wide, centred along the wall, 8 mm deep from the open edge
    translate([0, top - wall - 6, wall]) cube([12, wall + 1, 8]);
}