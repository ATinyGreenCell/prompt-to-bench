// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  difference() {
  union() {
    translate([0, 0, 0]) translate([-35, -25, 0]) cube([70, 50, 30]);
    translate([0, 0, 0]) translate([-32.8, -22.8, 0]) cube([65.6, 45.6, 2]);
  }
  translate([-33, -23, 2]) cube([66, 46, 29]);  // shell, wall 2, open top
}
  union() {
    translate([-10, 0, 0]) rotate([0, 0, 0]) translate([-35, -25, 0]) cube([70, 50, 30]);
  }
}