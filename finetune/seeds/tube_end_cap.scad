// Tube end cap - a cap that fits over the end of a round tube to close or protect it.
// NOVEL general part.
//
// @desc tube end cap that fits over the end of a round tube
// @prompt Design a tube end cap in OpenSCAD: a cap that fits over a {tube_d} mm outer-diameter tube, {depth} mm deep, with {wall} mm walls. Reply with a single complete OpenSCAD file.
// @param tube_d tube outer diameter, mm  [8:50]
// @param depth  cap depth, mm            [6:30]
// @param wall   wall thickness, mm       [1.5:4]

tube_d = 25;
depth  = 15;
wall   = 2.5;

$fn = 72;

difference() {
    cylinder(h = depth + wall, d = tube_d + 2 * wall);          // outer shell
    translate([0, 0, wall]) cylinder(h = depth + 1, d = tube_d + 0.4);   // pocket for the tube (0.2 mm clearance)
}
