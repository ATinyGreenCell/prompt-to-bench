// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([-85, 0, 2]) translate([-35, -25, 0]) cube([70, 50, 30]);
    translate([-85, 0, -1]) translate([-35, -25, 0]) cube([70, 50, 2]);
  }
  translate([-118, -23, 4]) cube([66, 46, 29]);  // shell, wall 2, open top
}
difference() {
  union() {
    translate([105, 0, 0]) translate([-35, -25, 0]) cube([70, 50, 2]);
  }
  union() {
    translate([0, 0, -0.01]) rotate([0, 0, 0]) translate([-32.8, -22.8, 0]) cube([65.6, 45.6, 2.02]);
  }
}