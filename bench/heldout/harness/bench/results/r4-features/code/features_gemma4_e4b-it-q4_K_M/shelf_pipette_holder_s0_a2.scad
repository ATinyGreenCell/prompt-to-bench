// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 105) polygon([[0, 0], [5, 0], [5, 28.4], [-25, 28.4], [-25, 0]]);
  }
  union() {
    translate([42, 17.5, 0]) rotate([0, 0, 0]) translate([-9.2, -15, 0]) cube([18.4, 30, 105]);
    translate([42, 52.5, 0]) rotate([0, 0, 0]) translate([-9.2, -15, 0]) cube([18.4, 30, 105]);
    translate([42, 87.5, 0]) rotate([0, 0, 0]) translate([-9.2, -15, 0]) cube([18.4, 30, 105]);
  }
}