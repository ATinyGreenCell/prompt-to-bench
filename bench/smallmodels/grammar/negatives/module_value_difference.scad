// negative: a CSG result assigned to a variable
// expect-reject-line: 3
plate = difference() { cube(10); sphere(5); };
cube(1);
