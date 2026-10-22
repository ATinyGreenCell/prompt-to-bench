// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-53, -36, 0]) cube([106, 72, 30]);
  }
  union() {
    translate([0, 0, 4.99]) rotate([0, 0, 0]) cylinder(d = 11.2, h = 25.02);
  }
}