// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, -15, 0]) translate([-25, -15, 0]) cube([50, 30, 40]);
  }
  union() {
    translate([0, 0, 9.99]) rotate([0, 0, 0]) cylinder(d = 16.5, h = 30.02);
    translate([0, -15, 28.99]) rotate([0, 0, 0]) translate([-17, -1.3, 0]) cube([34, 2.6, 11.02]);
  }
}