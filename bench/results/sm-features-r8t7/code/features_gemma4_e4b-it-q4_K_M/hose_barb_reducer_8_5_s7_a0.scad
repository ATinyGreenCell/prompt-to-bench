// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) rotate_extrude() polygon([[9, 0], [7.5, 10], [9.5, 20], [7.5, 30]]);
    translate([0, 0, 25]) rotate_extrude() polygon([[6.5, 25], [5, 33], [6.5, 41]]);
  }
  union() {
    translate([0, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 68);
  }
}