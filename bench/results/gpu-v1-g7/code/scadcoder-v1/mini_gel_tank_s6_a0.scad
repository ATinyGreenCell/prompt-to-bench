// Open-top rectangular buffer tank for a mini horizontal gel-electrophoresis box, with a
// central raised platform that spans the width and creates two buffer chambers, and
// horizontal electrode holes through each end wall. NOVEL general part.
//

tank_l = 120;
tank_w = 70;
tank_h = 40;
wall   = 3;
floor  = 3;
platform_t = 10;
electrode_d = 2;

$fn = 48;

inner_h = tank_h - wall - floor;
platform_z = floor + platform_t;

difference() {
    cube([tank_l, tank_w, tank_h]);
    translate([0, 0, floor]) cube([tank_l, tank_w, tank_h - floor]);                 // hollow the body except the floor
    translate([0, wall, floor]) cube([tank_l, tank_w - 2 * wall, inner_h]);           // cavity: open top, flat floor
    translate([-(tank_l / 2 - 15), wall, floor]) cube([tank_l / 2 - 15, tank_w - 2 * wall, inner_h]);   // left chamber
    translate([tank_l / 2 + 15, wall, floor]) cube([tank_l / 2 - 15, tank_w - 2 * wall, inner_h]);   // right chamber
    translate([-(tank_l / 2 - 15), 0, -1]) cube([tank_l / 2 - 15, wall + 2, tank_h + 2]);          // left end wall (solid, for the electrode hole)
    translate([tank_l / 2 + 15, 0, -1]) cube([tank_l / 2 - 15, wall + 2, tank_h + 2]);             // right end wall (solid, for the electrode hole)
    for (y = [-(tank_w / 2 - wall), tank_w / 2 - wall])
        translate([0, y, tank_h - 1]) rotate([-90, 0, 0]) cylinder(h = tank_w - 2 * wall + 2, d = electrode_d);   // electrode holes in the end walls
}