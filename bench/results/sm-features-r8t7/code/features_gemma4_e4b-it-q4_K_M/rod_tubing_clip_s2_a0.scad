// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-9.35, -1.5], [9.35, -1.5], [9.35, 1.5], [-9.35, 1.5]]);
  }
  union() {
    translate([-25, 0, 0]) rotate([0, 0, 0]) translate([-5, -4, 0]) cube([10, 8, 10]);
    translate([29.5, 0, 0]) rotate([0, 0, 0]) translate([-5, -2.25, 0]) cube([10, 4.5, 10]);
  }
}