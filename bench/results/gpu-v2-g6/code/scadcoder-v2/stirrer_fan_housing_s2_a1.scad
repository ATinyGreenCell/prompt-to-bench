// Fan motor housing - an open box (top open) that covers a round PC case fan, with a flat
// closed top that becomes the stirring surface. NOVEL general part.
//

top     = 2;
walls   = 2.5;
open_z  = 40;
X       = 90;
Y       = 90;
screw   = 4.5;
pattern = 71.5;
notch_w = 12;

$fn = 48;

inner_x = X - 2 * walls;
inner_y = Y - 2 * walls;
open_e  = min(inner_x, inner_y);   // the fan is round; the open edge is a circle of this diameter

difference() {
    union() {
        translate([-X / 2, -Y / 2, 0]) cube([X, Y, top]);                                     // top plate
        for (z = [top + 0.01 : walls - 0.01 : open_z - walls + 0.01])
            translate([-X / 2, -Y / 2, z]) cube([X, Y, walls]);                               // walls
    }
    translate([-X / 2, -Y / 2, top + 1]) cylinder(h = open_z - top - 1, d = open_e);         // hollow, open at the top
    for (x = [-(pattern / 2), (pattern / 2)]; y = [-(pattern / 2), (pattern / 2)])
        translate([x, y, -1]) cylinder(h = top + 2, d = screw);                              // screw holes through the top plate
    // cable notch: one wall, centred along the wall, 12 mm wide, 8 mm down from the open edge
    translate([-X / 2, -Y / 2, open_z - walls]) cube([X, Y, walls]);                          // the wall to cut
    translate([0, -Y / 2 - 1, open_z - walls + 8]) cube([X, Y + 2, notch_w]);                 // remove the notch
}