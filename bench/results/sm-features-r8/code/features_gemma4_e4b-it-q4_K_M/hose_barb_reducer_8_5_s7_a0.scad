// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) rotate_extrude() polygon([[7.5, 0], [9.5, 10], [7.5, 20], [5, 25], [6.5, 33]]);
  }
  union() {
    translate([0, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 35);
  }
}