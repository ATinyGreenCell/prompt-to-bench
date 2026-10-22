// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) rotate_extrude() polygon([[4, 0], [7.5, 20], [9.5, 30], [7.5, 38]]);
    translate([0, 0, 20]) difference() { cylinder(d = 12, h = 16); translate([0, 0, -0.01]) cylinder(d = 11.8, h = 16.02); }
  }
  union() {
    translate([0, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 40);
  }
}