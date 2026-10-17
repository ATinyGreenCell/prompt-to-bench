// Fan cover - a simple open box (open top) that mounts over a round PC case fan to turn it into
// a magnetic stirrer. The top plate is the stirring surface. This is the print orientation: the
// top plate lies on the bed (z = 0) and the walls rise upward. NOVEL general part.
//

top     = 2;
walls   = 2.5;
open_z  = 40;
X       = 90;
Y       = 90;
screw   = 4.5;
pattern = 71.5;
notch_w = 12;
notch_d = 8;

$fn = 48;

inner_x = X - 2 * walls;
inner_y = Y - 2 * walls;
open_e  = open_z - walls;   // top of the walls (the rim the open top sits on)

difference() {
    cube([X, Y, open_z]);
    translate([walls, walls, walls]) cube([inner_x, inner_y, open_z - walls]);   // hollow, open top
    for (i = [0:3])
        rotate([0, 0, 90 * i])
            translate([-pattern / 2, -pattern / 2, 0])
                cylinder(h = top + 1, d = screw);                                  // screw holes
    // cable notch in one wall (front left, open edge facing +X): 12 mm wide, 8 mm deep
    translate([-X / 2, -Y / 2, open_e - notch_d]) cube([X, notch_w, notch_d]);
}