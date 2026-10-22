// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-65, -45, 0]) cube([130, 90, 4]);
  }
  union() {
    translate([-20, -20.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1016, center = true);
    translate([60, -20.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1016, center = true);
    translate([100, -20.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1016, center = true);
    translate([-20, 20.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1016, center = true);
    translate([60, 20.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1016, center = true);
    translate([100, 20.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1016, center = true);
  }
}
union() {
    translate([-65, -35, 0]) translate([-65, -2, 0]) cube([130, 4, 70]);
    translate([-65, 55, 0]) translate([-65, -2, 0]) cube([130, 4, 70]);
  }