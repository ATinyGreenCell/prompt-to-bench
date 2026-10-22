// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-65, -45, 0]) cube([130, 90, 4]);
    translate([-65, -22.5, 0]) translate([-65, -2, 0]) cube([130, 4, 70]);
    translate([-65, 45, 0]) translate([-65, -2, 0]) cube([130, 4, 70]);
  }
  union() {
    translate([-40, -22.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1280, center = true);
    translate([0, -22.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1280, center = true);
    translate([40, -22.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1280, center = true);
    translate([-40, 22.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1280, center = true);
    translate([0, 22.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1280, center = true);
    translate([40, 22.5, 4]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 30.5, h = 1280, center = true);
  }
}