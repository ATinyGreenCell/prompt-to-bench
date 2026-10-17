// Fan motor housing - an open box (top open) that covers a round PC case fan to turn it
// into a magnetic stirrer. The top plate is the stirring surface. This is the print
// orientation: the top plate lies on the bed (z = 0) and the walls rise upward.
//

top     = 90;
width   = 90;
height  = 40;
wall    = 2.5;
screw   = 4.5;
pattern = 71.5;
notch   = 12;

$fn = 48;

inner_h = height - wall;

difference() {
    cube([top, width, height]);
    translate([top / 2, width / 2, wall]) cube([top - 0.01, width - 0.01, inner_h]);   // open top: a floor with no ceiling
    for (x = [-pattern / 2 : pattern / 2])
        for (y = [-pattern / 2 : pattern / 2])
            translate([x, y, -1]) cylinder(h = height + 2, d = screw);                                                      // screw holes through the top plate
    translate([top / 2, width / 2, height - 1])
        cube([top - 0.01, width - 0.01, 1]);  // open top: a floor with no ceiling
    // cable notch: 12 mm wide, centred along the wall, reaching 8 mm down from the open edge (from z = 32 to z = 40)
    translate([top / 2, width / 2, 32]) cube([top, width, 8]);
    translate([top / 2, width / 2, height - 1])
        cube([top - 0.01, width - 0.01, 1]);  // open top: a floor with no ceiling
}