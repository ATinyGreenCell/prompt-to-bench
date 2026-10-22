// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-65, -30, 0]) cube([130, 60, 45]);
  }
  union() {
    translate([-12, -10, 4.99]) rotate([0, 0, 0]) cylinder(d = 17.5, h = 40.02);
    translate([-12, -10, 4.99]) rotate([0, 0, 0]) cylinder(d = 17.5, h = 40.02);
    translate([-12, -10, 4.99]) rotate([0, 0, 0]) cylinder(d = 17.5, h = 40.02);
    translate([-12, -10, 4.99]) rotate([0, 0, 0]) cylinder(d = 17.5, h = 40.02);
    translate([-12, -10, 4.99]) rotate([0, 0, 0]) cylinder(d = 17.5, h = 40.02);
  }
}