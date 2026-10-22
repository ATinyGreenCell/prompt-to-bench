// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([-30, -12, 0]) translate([-30, -12, 0]) cube([60, 24, 16]);
  }
  union() {
    translate([-30, 0, 7.99]) rotate([0, 0, 0]) cylinder(d = 4.2, h = 8.02);
    translate([-15, -12, 0]) rotate([0, 0, 0]) translate([-1.5, -1.5, 0]) cube([3, 3, 16]);
    translate([15, -12, 0]) rotate([0, 0, 0]) translate([-1.5, -1.5, 0]) cube([3, 3, 16]);
    translate([-15, 12, 9.99]) rotate([0, 0, 0]) cylinder(d = 4.2, h = 6.02);
    translate([0, 12, 9.99]) rotate([0, 0, 0]) cylinder(d = 4.2, h = 6.02);
    translate([15, 12, 9.99]) rotate([0, 0, 0]) cylinder(d = 4.2, h = 6.02);
    translate([-25, -6, 8]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 3.4, h = 1064, center = true);
    translate([25, -6, 8]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 3.4, h = 1064, center = true);
  }
}