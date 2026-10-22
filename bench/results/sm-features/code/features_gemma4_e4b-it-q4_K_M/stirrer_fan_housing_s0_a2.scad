// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-45, -45, 0]) cube([90, 90, 42]);
  }
  union() {
    translate([0, 0, 0]) rotate([0, 0, 0]) translate([-35.75, -35.75, 0]) cube([71.5, 71.5, 42]);
    translate([-42.5, -135, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([-42.5, -45, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([-42.5, 45, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([-42.5, 135, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([-135, -42.5, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([-45, -42.5, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([45, -42.5, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([135, -42.5, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([0, -92.5, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([0, -2.5, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([0, 87.5, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([0, 177.5, 2]) rotate([0, 0, 0]) translate([-45, -1.25, 0]) cube([90, 2.5, 38]);
    translate([-92.5, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([-2.5, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([87.5, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([177.5, 0, 2]) rotate([0, 0, 0]) translate([-1.25, -45, 0]) cube([2.5, 90, 38]);
    translate([-42.5, 0, 32]) rotate([0, 0, 0]) translate([-6, -1.25, 0]) cube([12, 2.5, 8]);
  }
}