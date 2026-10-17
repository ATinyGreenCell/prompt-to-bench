// Magnetic stirrer housing - an open box (top open) that mounts over a PC case fan to enclose
// the blades while allowing the shaft to pass through. The open top is the stirring surface. NOVEL
// general part.
//

top     = 90;
length  = 90;
height  = 40;
wall    = 2.5;
screw   = 4.5;
cable   = 12;

$fn = 48;

difference() {
    cube([top, length, height + wall]);
    translate([top * 0.5, length * 0.5, -1]) cube([top, length, 1]);                 // open top
    for (z = [wall, height * 0.25, height * 0.75, height])
        translate([top / 2, length / 2, z]) rotate([0, 90, 0]) cylinder(h = wall, d = screw);   // screw holes
    translate([0, length / 2 - cable / 2, height - 8]) cube([cable, length, wall + 8]);           // cable notch in one wall
}