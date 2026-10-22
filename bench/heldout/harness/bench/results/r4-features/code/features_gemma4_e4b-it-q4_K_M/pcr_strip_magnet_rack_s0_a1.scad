// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-40, -12, 0]) cube([80, 24, 20]);
  }
  union() {
    translate([0, -36.5, 7.99]) rotate([0, 0, 0]) cylinder(d = 6.4, h = 12.02);
  }
}