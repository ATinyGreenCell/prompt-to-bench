// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-65, -45, 0]) cube([130, 90, 4]);
    translate([0, -45, 0]) linear_extrude(height = 70) polygon([[-65, -2], [-65, 2], [65, 2], [65, -2]]);
    translate([0, 0, 0]) linear_extrude(height = 70) polygon([[-2, -45], [2, -45], [2, 45], [-2, 45]]);
  }
  union() {
    translate([-40, -40, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([40, -40, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([-40, 40, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
    translate([40, 40, -1]) rotate([0, 0, 0]) cylinder(d = 30.5, h = 72);
  }
}