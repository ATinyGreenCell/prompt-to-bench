// negative: return inside a module body
// expect-reject-line: 4
module plate() {
    return cube([20, 30, 5]);
}
plate();
