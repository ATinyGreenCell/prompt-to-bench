// negative: a Python for loop
// expect-reject-line: 3
for i in range(4):
    translate([i * 10, 0, 0]) cube(5);
