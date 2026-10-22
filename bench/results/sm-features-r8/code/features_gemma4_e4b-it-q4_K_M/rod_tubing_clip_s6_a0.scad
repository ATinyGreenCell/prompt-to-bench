// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-9.35, -1.5], [9.35, -1.5], [9.35, 1.5], [-9.35, 1.5]]);
  }
  union() {
    translate([-10, 0, 0]) rotate([0, 0, 0]) translate([-5, -5, 0]) cube([10, 10, 10]);
    translate([20, 0, 0]) rotate([0, 0, 0]) translate([-5, -2.5, 0]) cube([10, 5, 10]);
  }
}