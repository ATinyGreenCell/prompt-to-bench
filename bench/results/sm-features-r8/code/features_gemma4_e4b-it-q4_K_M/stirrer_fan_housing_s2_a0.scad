// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-45, -45, 0]) cube([90, 90, 2]);
  }
  union() {
    translate([0, 0, -2]) rotate([0, 0, 0]) translate([-35.75, -35.75, 0]) cube([71.5, 71.5, 2]);
    translate([0, -135, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([0, -45, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([0, 45, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([0, 135, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([-135, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
    translate([-45, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
    translate([45, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
    translate([135, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
    translate([0, -135, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([0, -45, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([0, 45, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([0, 135, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 40]);
    translate([-135, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
    translate([-45, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
    translate([45, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
    translate([135, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 40]);
  }
}