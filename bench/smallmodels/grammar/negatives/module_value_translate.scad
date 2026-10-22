// negative: a transformed module assigned to a variable
// expect-reject-line: 3
b = translate([1, 0, 0]) cube(1);
cube(2);
