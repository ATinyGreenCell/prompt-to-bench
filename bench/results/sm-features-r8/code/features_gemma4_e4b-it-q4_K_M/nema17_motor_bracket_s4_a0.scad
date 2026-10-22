// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([-25, 0, 0]) translate([-25, -22.5, 0]) cube([50, 45, 5]);
    translate([-25, 0, 0]) translate([-25, -2.5, 0]) cube([50, 5, 50]);
  }
  union() {
    translate([-17, 30, 3.75]) rotate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 4.5, h = 1200, center = true);
    translate([17, 30, 3.75]) rotate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 4.5, h = 1200, center = true);
    translate([0, 0, 28]) rotate([0, 0, 0]) translate([-11.5, -15.5, 0]) cube([23, 31, 50]);
  }
}
union() {
    translate([-25, 0, 0]) linear_extrude(height = 50) polygon([[-25, 0], [25, 0], [25, 5], [-25, 5]]);
  }