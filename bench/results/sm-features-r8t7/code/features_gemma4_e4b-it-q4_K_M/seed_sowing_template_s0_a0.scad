// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 85, h = 2);
  }
  union() {
    translate([0, 0, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([9, 0, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-9, 0, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([18, 0, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-18, 0, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([27, 0, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-27, 0, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([9, 9, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-9, 9, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([18, 9, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-18, 9, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([27, 9, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-27, 9, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([9, 18, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-9, 18, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([18, 18, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-18, 18, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([27, 18, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([-27, 18, -0.01]) rotate([0, 0, 0]) cylinder(d = 3, h = 2.02);
    translate([0, 65.5, 0]) rotate([0, 0, 0]) translate([-5, -2, 0]) cube([10, 4, 2]);
  }
}