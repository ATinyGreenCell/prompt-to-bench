// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-65, -45, 0]) cube([130, 90, 4]);
    translate([-65, -22.5, 0]) translate([-65, -2, 0]) cube([130, 4, 70]);
    translate([-65, 47.5, 0]) translate([-65, -2, 0]) cube([130, 4, 70]);
  }
  union() {
    translate([-20, -35.5, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([20, -35.5, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([40, -35.5, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([-20, 17.5, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([20, 17.5, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([40, 17.5, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
  }
}