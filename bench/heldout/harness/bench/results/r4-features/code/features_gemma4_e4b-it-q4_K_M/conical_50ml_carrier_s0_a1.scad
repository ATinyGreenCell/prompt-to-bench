// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-45, -45, 0]) cube([90, 90, 35]);
  }
  union() {
    translate([-21, -24, 30]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1140, center = true);
    translate([-21, 24, 30]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1140, center = true);
    translate([21, -24, 30]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1140, center = true);
    translate([21, 24, 30]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1140, center = true);
  }
}
difference() {
  union() {
    translate([-45, 0, 0]) translate([-8, -45, 0]) cube([16, 90, 160]);
    translate([45, 0, 0]) translate([-8, -45, 0]) cube([16, 90, 160]);
  }
  union() {
    translate([-45, 0, 35]) rotate([0, 0, 0]) translate([-5.2, -5.2, 0]) cube([10.4, 10.4, 150]);
    translate([45, 0, 35]) rotate([0, 0, 0]) translate([-5.2, -5.2, 0]) cube([10.4, 10.4, 150]);
  }
}
union() {
    translate([0, 60, 0]) translate([-50, -5, 0]) cube([100, 10, 10]);
  }