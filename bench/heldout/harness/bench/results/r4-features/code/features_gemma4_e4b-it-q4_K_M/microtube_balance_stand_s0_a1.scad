// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 50, h = 4);
    translate([0, 0, 0]) rotate_extrude() polygon([[25, 4], [11, 23], [22, 33]]);
    translate([0, 0, 14]) cylinder(d = 22, h = 19);
  }
  union() {
    translate([0, 0, 22.99]) rotate([0, 0, 0]) cylinder(d = 11, h = 10.02);
    translate([0, 0, 0.5]) difference() { cylinder(d = 24, h = 11); translate([0, 0, -1]) cylinder(d = 16, h = 13); }
    translate([0, 0, 18]) rotate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 4, h = 1132, center = true);
  }
}