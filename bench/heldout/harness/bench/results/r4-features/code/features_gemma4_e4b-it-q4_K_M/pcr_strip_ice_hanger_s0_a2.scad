// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
union() {
    translate([-42, 0, 0]) linear_extrude(height = 84) polygon([[0, 0], [0, 20.5], [16.5, 20.5], [16.5, 0]]);
  }
difference() {
  union() {
    translate([0, -15, 0]) translate([-15, -3, 0]) cube([30, 6, 6]);
  }
  union() {
    translate([-9, -15, 3.2]) rotate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 6.4, h = 1024, center = true);
  }
}