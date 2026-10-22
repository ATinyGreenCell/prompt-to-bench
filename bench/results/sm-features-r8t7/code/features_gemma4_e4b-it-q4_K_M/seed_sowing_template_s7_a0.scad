// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, -1]) cylinder(d = 85, h = 2);
  }
  union() {
    translate([0, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([9, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([-9, 0, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([0, 9, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([0, -9, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([9, 9, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([-9, 9, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([9, -9, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([-9, -9, -1]) rotate([0, 0, 0]) cylinder(d = 3, h = 4);
    translate([0, 85, 0]) rotate([0, 0, 0]) translate([-5, -2, 0]) cube([10, 4, 2]);
  }
}