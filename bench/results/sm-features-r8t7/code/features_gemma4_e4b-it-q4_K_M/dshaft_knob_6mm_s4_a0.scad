// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 30, h = 15);
  }
  union() {
    translate([0, 0, 2.99]) rotate([0, 0, 0]) cylinder(d = 6.2, h = 12.02);
    translate([0, 0, 13.99]) rotate([0, 0, 0]) translate([-0.75, -15, 0]) cube([1.5, 30, 1.02]);
  }
}