// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-9.35, -3], [9.35, -3], [9.35, 3], [-9.35, 3]]);
    translate([15, 0, 0]) linear_extrude(height = 10) polygon([[12, -1], [18, -1], [18, 1], [12, 1]]);
  }
  union() {
    translate([-18.7, 0, 0]) rotate([0, 0, 0]) translate([-5, -5, 0]) cube([10, 10, 3]);
    translate([15, -2.25, 0]) rotate([0, 0, 0]) translate([-1, -4.5, 0]) cube([2, 9, 3]);
  }
}