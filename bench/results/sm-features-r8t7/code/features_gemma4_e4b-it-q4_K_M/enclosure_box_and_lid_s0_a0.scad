// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([-35, -25, 0]) translate([-35, -25, 0]) cube([70, 50, 30]);
    translate([-115, -25, 0]) translate([-32.8, -22.8, 0]) cube([65.6, 45.6, 2]);
  }
  translate([-68, -48, 2]) cube([66, 46, 29]);  // shell, wall 2, open top
}
union() {
    translate([35, -25, 0]) translate([-35, -25, 0]) cube([70, 50, 2]);
  }