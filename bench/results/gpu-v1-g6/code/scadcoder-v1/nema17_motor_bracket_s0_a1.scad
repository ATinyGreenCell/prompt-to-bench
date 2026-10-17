// L-shaped mounting bracket - a base plate with two mounting holes and a vertical motor plate with a
// motor boss hole and a screw pattern, reinforced with two triangular gussets. NOVEL general part.
//

base_x   = 50;
base_y   = 45;
base_t   = 5;
tunnel   = 4.5;
plate_h  = 50;
screw_p  = 31;
boss_d   = 23;
gusset_t = 5;

$fn = 48;

g = min(tunnel, screw_p / 2 - 1.5, (boss_d / 2 - 1));        // keep a wall between the boss hole and the screw holes

difference() {
    union() {
        cube([base_x, base_y, base_t]);                 // base plate
        cube([base_x, 5, plate_h]);                     // motor plate (stands on the back edge of the base)
        for (x = [-base_x / 2, base_x / 2])
            translate([x, 0, 0])
                cube([gusset_t, base_y, 20]);           // gussets: right triangles in the YZ plane, right angle at (y=5, z=5)
    }
    translate([-17, 0, -1]) cylinder(h = base_t + 2, d = tunnel);                      // base mounting hole
    translate([17, 0, -1]) cylinder(h = base_t + 2, d = tunnel);
    translate([0, -1, 28]) rotate([0, 90, 0]) cylinder(h = base_y + 2, d = boss_d);   // motor boss hole (along Y)
    for (p = screw_p / 2)
        translate([0, -p, 28]) rotate([0, 90, 0]) cylinder(h = base_y + 2, d = g);    // screw pattern (along Y)
}