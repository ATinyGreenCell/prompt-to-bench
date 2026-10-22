// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-9.35, -3], [-9.35, 3], [18.7, 3], [18.7, -3]]);
    translate([15, 0, 0]) linear_extrude(height = 10) polygon([[-2.75, -1], [-2.75, 1], [21, 1], [21, -1]]);
  }
  union() {
    translate([-17.85, 0, 0]) rotate([0, 0, 0]) translate([-4.675, -3, 0]) cube([9.35, 6, 10]);
    translate([20.25, 0, 0]) rotate([0, 0, 0]) translate([-0.75, -2.25, 0]) cube([1.5, 4.5, 10]);
  }
}