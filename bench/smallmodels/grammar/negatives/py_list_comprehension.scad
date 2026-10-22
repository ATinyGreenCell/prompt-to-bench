// negative: a Python list comprehension
// expect-reject-line: 3
xs = [i * 10 for i in [0 : 3]];
for (x = xs) translate([x, 0, 0]) cube(5);
