// negative: no semicolon after the last module call in a block
// expect-reject-line: 6
difference() {
    cube([20, 30, 5]);
    translate([4, 4, -1]) cylinder(d = 3, h = 7)
}
