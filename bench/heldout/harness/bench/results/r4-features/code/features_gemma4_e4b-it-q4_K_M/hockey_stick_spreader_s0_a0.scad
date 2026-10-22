// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([75, 0, 2]) translate([-75, -3, 0]) cube([150, 6, 4]);
    translate([0, 0, 1.25]) translate([-20, -2.5, 0]) cube([40, 5, 2.5]);
  }
  union() {
    translate([143, 0, 1.99]) rotate([0, 0, 0]) cylinder(d = 4, h = 4.02);
  }
}