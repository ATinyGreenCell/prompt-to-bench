// negative: += does not exist in OpenSCAD
// expect-reject-line: 4
x = 1;
x += 2;
cube(x);
