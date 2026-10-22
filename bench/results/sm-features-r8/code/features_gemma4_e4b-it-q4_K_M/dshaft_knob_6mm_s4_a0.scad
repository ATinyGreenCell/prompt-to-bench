// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 30, h = 15);
  }
  union() {
    translate([0, 0, 2.99]) rotate([0, 0, 0]) cylinder(d = 6.2, h = 12.02);
    translate([0, 0, -0.01]) rotate([0, 0, 90]) hull() { for (s = [-1, 1]) translate([s * 14, 0, 0]) cylinder(d = 2, h = 15.02); }
    translate([0, 0, 13.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 6.75, 0, 0]) cylinder(d = 1.5, h = 1.02); }
  }
}