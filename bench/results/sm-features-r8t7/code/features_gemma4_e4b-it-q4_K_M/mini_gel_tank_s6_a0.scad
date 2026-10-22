// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-60, -35, 0]) cube([120, 70, 40]);
  }
  union() {
    translate([0, 0, 3]) rotate([0, 0, 0]) translate([-60, -35, 0]) cube([120, 70, 37]);
    translate([0, 0, -3]) rotate([0, 0, 0]) translate([-60, -35, 0]) cube([120, 70, 3]);
  }
}
union() {
    translate([-30, 0, 13]) translate([-30, -35, 0]) cube([60, 70, 10]);
  }