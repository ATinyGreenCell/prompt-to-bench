// Fan cover - an open box (top open) that mounts over a round PC case fan to turn it into a
// magnetic stirrer. The top plate is the stirring surface. This is the print orientation: the
// top plate lies on the bed (z = 0) and the walls rise upward.
//

top     = 90;
width   = 90;
height  = 40;
wall    = 2.5;
screw   = 4.5;
pattern = 71.5;
notch   = 12;

$fn = 48;

plate_h = 2;

difference() {
    cube([top, width, height + plate_h]);
    translate([top / 2, width / 2, plate_h]) cube([top, width, height]);       // hollow inside
    for (x = [-pattern / 2, pattern / 2])
        for (y = [-pattern / 2, pattern / 2])
            translate([x, y, -1]) cylinder(h = height + plate_h + 2, d = screw);  // screw holes
    // cable notch: 12 mm wide, centred along the wall, reaching 8 mm down from the open edge
    translate([top / 2, width / 2, height - 10]) cube([top, width, 10]);        // block one wall end
    translate([top / 2, width / 2, height - 10]) cube([top, width, 10]);        // block the opposite wall end
    translate([top / 2, width / 2, height - 10]) cube([top, width, 10]);        // block the opposite wall end
    translate([top / 2, width / 2, height - 10]) cube([top, width, 10]);        // block the opposite wall end
}