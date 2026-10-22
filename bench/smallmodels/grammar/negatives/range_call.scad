// negative: range() from Python
// expect-reject-line: 3
for (i = range(4)) translate([i * 5, 0, 0]) cube(2);
