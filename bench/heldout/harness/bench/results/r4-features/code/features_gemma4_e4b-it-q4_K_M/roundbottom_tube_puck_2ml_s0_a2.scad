// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 80, h = 26);
  }
  union() {
    translate([-17, 0, 0]) rotate([0, 0, 0]) translate([-17, -40, 0]) cube([34, 80, 26]);
    translate([0, 0, 5.99]) rotate([0, 0, 0]) cylinder(d = 11.2, h = 20.02);
  }
}