// negative: a function with a body in braces
// expect-reject-line: 3
function area(w, h) { return w * h; }
cube(area(2, 3));
