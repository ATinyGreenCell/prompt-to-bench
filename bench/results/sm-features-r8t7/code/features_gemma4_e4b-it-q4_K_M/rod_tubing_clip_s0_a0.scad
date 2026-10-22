// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-9.35, -1.5], [9.35, -1.5], [9.35, 1.5], [-9.35, 1.5]]);
    translate([15, 0, 0]) linear_extrude(height = 10) polygon([[-2.75, -1], [4.75, -1], [4.75, 1], [-2.75, 1]]);
  }
  union() {
    translate([-9.35, -4, 0]) rotate([0, 0, 0]) translate([-5, -3, 0]) cube([10, 6, 10]);
    translate([17.25, -2.25, 0]) rotate([0, 0, 0]) translate([-1, -3, 0]) cube([2, 6, 10]);
  }
}