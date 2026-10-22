// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-63.88, -42.74, 0]) cube([127.76, 85.48, 20]);
  }
  union() {
    translate([14.38, 11.24, 0]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 6.2, h = 1080, center = true);
    translate([14.38, 11.24, 0]) rotate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 6.2, h = 1080, center = true);
  }
}
union() {
    translate([-127.76, -85.48, 0]) translate([-2.5, -2.5, 0]) cube([5, 5, 20]);
  }