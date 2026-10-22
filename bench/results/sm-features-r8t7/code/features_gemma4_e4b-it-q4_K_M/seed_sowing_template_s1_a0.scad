// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 85, h = 2);
  }
  union() {
    translate([0, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([-45, -45, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([0, -45, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([45, -45, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([-45, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([45, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([-45, 45, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([0, 45, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([45, 45, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
  }
}