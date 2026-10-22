// negative: no semicolon after a module call (OpenSCAD would make the next line an ignored child)
// expect-reject-line: 4
cube([20, 30, 5])
translate([4, 4, 0]) cylinder(d = 3, h = 6);
