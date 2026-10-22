// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 10) polygon([[-9.35, -3], [9.35, -3], [9.35, 3], [-9.35, 3]]);
    translate([15, 0, 0]) linear_extrude(height = 10) polygon([[-2.75, -1], [4.25, -1], [4.25, 1], [-2.75, 1]]);
  }
  union() {
    translate([-9.35, 0, -5]) rotate([0, 0, 0]) translate([-5, -5, 0]) cube([10, 10, 10]);
  }
}
difference() {
  union() {
    translate([15, 0, 0]) linear_extrude(height = 10) polygon([[-2.75, -1], [4.25, -1], [4.25, 1], [-2.75, 1]]);
  }
  union() {
    translate([19.25, 0, -2.25]) rotate([0, 0, 0]) translate([-2.25, -2.5, 0]) cube([4.5, 5, 10]);
  }
}