// negative: a built-in module assigned to a variable
// expect-reject-line: 3
rack = cube([10, 10, 10]);
translate([0, 0, 10]) cube(1);
