// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-18.7, -3], [18.7, -3], [18.7, 3], [-18.7, 3]]);
    translate([15, 0, 0]) linear_extrude(height = 10) polygon([[-2.25, -2], [2.25, -2], [2.25, 2], [-2.25, 2]]);
  }
  union() {
    translate([-18.7, 0, 0]) rotate([0, 0, 0]) translate([-5, -5, 0]) cube([10, 10, 3]);
    translate([17.25, 0, 0]) rotate([0, 0, 0]) translate([-1.125, -5, 0]) cube([2.25, 10, 3]);
  }
}