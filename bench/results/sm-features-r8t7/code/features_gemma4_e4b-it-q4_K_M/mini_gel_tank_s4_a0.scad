// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-60, -35, 0]) cube([120, 70, 40]);
  }
  union() {
    translate([0, 0, 0]) rotate([0, 0, 0]) translate([-60, -35, 0]) cube([120, 70, 37]);
    translate([-2, -18, 13]) rotate([0, 0, 0]) translate([-57, -32, 0]) cube([114, 64, 10]);
  }
}