// negative: a block that is never closed
// expect-reject-line: end
difference() {
    cube(10, center = true);
    sphere(6);
