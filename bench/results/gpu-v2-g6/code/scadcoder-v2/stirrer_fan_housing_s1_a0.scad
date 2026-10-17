// Fan cover - a simple open box (open top) that mounts over a round PC case fan to turn it into
// a magnetic stirrer. The top plate is the stirring surface. This is the print orientation: the
// top plate lies on the bed (z = 0) and the walls rise upward.
//

top     = 2;
walls   = 2.5;
open_z  = 40;
X       = 90;
Y       = 90;
screw   = 4.5;
pattern = 71.5;
cable_w = 12;

$fn = 48;

inner_x = X - 2 * walls;
inner_y = Y - 2 * walls;
open_e  = open_z - walls;       // top of the walls (the rim the open top sits on)

difference() {
    cube([X, Y, open_z]);
    translate([walls, walls, open_e]) cube([inner_x, inner_y, walls + 1]);   // hollow, open top
    for (i = [0:3])
        rotate([0, 0, 45 * i])
            translate([0, -1.5, -1]) cylinder(h = walls + 2, d = screw);                                          // screw holes through the top plate
    translate([X / 2, -1, open_e - 12]) rotate([-90, 0, 0]) rectangle([cable_w, 16]);                           // cable notch: 12 mm wide, 16 mm deep, centred along the wall
}