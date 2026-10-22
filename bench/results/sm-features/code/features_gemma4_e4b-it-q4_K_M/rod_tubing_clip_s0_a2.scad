// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-9.35, -1.5], [9.35, -1.5], [9.35, 1.5], [-9.35, 1.5]]);
    translate([15, 0, 0]) linear_extrude(height = 10) polygon([[-2.75, -1], [2.75, -1], [2.75, 1], [-2.75, 1]]);
  }
  union() {
    translate([-18.7, -1.5, 0]) rotate([0, 0, 0]) translate([-5, -1.5, 0]) cube([10, 3, 10]);
    translate([20.75, -1.5, 0]) rotate([0, 0, 0]) translate([-5, -1.5, 0]) cube([10, 3, 10]);
  }
}