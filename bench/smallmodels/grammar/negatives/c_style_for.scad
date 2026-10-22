// negative: a C-style for statement
// expect-reject-line: 3
for (i = 0; i < 4; i++) translate([i * 10, 0, 0]) cube(5);
