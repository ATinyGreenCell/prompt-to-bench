// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([-35, 0, 1.5]) translate([-35, -25, 0]) cube([70, 50, 30]);
  }
  translate([-68, -23, 3.5]) cube([66, 46, 29]);  // shell, wall 2, open top
}
difference() {
  union() {
    translate([-35, 0, -1]) translate([-32.8, -22.8, 0]) cube([65.6, 45.6, 2]);
    translate([-35, 0, 1.5]) translate([-32.8, -22.8, 0]) cube([65.6, 45.6, 4]);
  }
  union() {
    translate([-35, 0, 3.49]) rotate([0, 0, 0]) translate([-35, -25, 0]) cube([70, 50, 2.02]);
  }
}