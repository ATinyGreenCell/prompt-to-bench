// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 30, h = 15);
  }
  union() {
    translate([0, 0, 2.99]) rotate([0, 0, 0]) cylinder(d = 6.2, h = 12.02);
    translate([0, 0, -1]) rotate([0, 0, 0]) translate([-2.35, -1, 0]) cube([4.7, 2, 15]);
  }
}