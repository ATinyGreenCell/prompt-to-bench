// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-65, -45, 0]) cube([130, 90, 4]);
    translate([-65, -90, 0]) rotate([0, 0, 0]) translate([-65, -2, 0]) cube([130, 4, 70]); translate([-65, 0, 0]) rotate([0, 0, 0]) translate([-65, -2, 0]) cube([130, 4, 70]);
    translate([0, -45, 0]) rotate([0, 0, 0]) translate([-2, -45, 0]) cube([4, 90, 70]); translate([0, -45, 0]) rotate([0, 0, 0]) translate([-2, -45, 0]) cube([4, 90, 70]); translate([0, -45, 0]) rotate([0, 0, 0]) translate([-2, -45, 0]) cube([4, 90, 70]);
  }
  union() {
    translate([-40, -60, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([0, -60, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([40, -60, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([-40, -20, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([0, -20, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([40, -20, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
  }
}