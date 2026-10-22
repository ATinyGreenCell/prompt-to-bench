// negative: for (x in ...) - OpenSCAD needs for (x = ...)
// expect-reject-line: 3
for (i in [0 : 3]) translate([i * 10, 0, 0]) cube(5);
