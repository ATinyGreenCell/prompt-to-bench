// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-45, -22.5, 0]) cube([90, 45, 20]);
  }
  union() {
    translate([0, -18.75, 9.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 37.7, 0, 0]) cylinder(d = 1.6, h = 10.02); }
  }
}