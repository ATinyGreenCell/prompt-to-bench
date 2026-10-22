// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 8, h = 45);
    translate([0, 0, 45]) cylinder(d1 = 8, d2 = 3, h = 17);
    translate([0, 0, 62]) cylinder(d = 3, h = 12);
  }
  union() {
    translate([0, 0, 9]) difference() { cylinder(d = 10, h = 2); translate([0, 0, -1]) cylinder(d = 6, h = 4); }
    translate([0, 0, 14]) difference() { cylinder(d = 10, h = 2); translate([0, 0, -1]) cylinder(d = 6, h = 4); }
    translate([0, 0, 19]) difference() { cylinder(d = 10, h = 2); translate([0, 0, -1]) cylinder(d = 6, h = 4); }
    translate([0, 0, 24]) difference() { cylinder(d = 10, h = 2); translate([0, 0, -1]) cylinder(d = 6, h = 4); }
  }
}