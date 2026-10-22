// negative: elif instead of else if
// expect-reject-line: 5
a = true;
if (a) cube(1);
elif (!a) sphere(1);
