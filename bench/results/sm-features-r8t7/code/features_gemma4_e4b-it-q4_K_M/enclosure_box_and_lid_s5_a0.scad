// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([-85, 0, 2]) translate([-35, -25, 0]) cube([70, 50, 30]);
  }
  union() {
    translate([-85, 0, 2]) rotate([0, 0, 0]) translate([-33, -23, 0]) cube([66, 46, 28]);
  }
}
union() {
    translate([10, 0, 0]) translate([-35, -25, 0]) cube([70, 50, 2]);
  }