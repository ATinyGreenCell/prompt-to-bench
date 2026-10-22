// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-45, -22.5, 0]) cube([90, 45, 20]);
  }
  union() {
    translate([0, -37.5958, 9.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 37.7, 0, 0]) cylinder(d = 1.6, h = 10.02); }
    translate([0, -24.0958, 9.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 37.7, 0, 0]) cylinder(d = 1.6, h = 10.02); }
    translate([0, 7.4042, 9.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 37.7, 0, 0]) cylinder(d = 1.6, h = 10.02); }
    translate([0, 20.9042, 9.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 37.7, 0, 0]) cylinder(d = 1.6, h = 10.02); }
    translate([0, 34.4042, 9.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 37.7, 0, 0]) cylinder(d = 1.6, h = 10.02); }
  }
}