// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) linear_extrude(height = 3) polygon([[-45, -38.97], [45, -38.97], [45, 38.97], [-45, 38.97]]);
    translate([0, 0, 3]) linear_extrude(height = 17) polygon([[-42, -19.69], [42, -19.69], [42, 19.69], [-42, 19.69]]);
    translate([54, 0, 3]) rotate([0, 0, 0]) linear_extrude(height = 17) polygon([[-42, -19.69], [42, -19.69], [42, 19.69], [-42, 19.69]]); translate([27, 46.7654, 3]) rotate([0, 0, 60]) linear_extrude(height = 17) polygon([[-42, -19.69], [42, -19.69], [42, 19.69], [-42, 19.69]]); translate([-27, 46.7654, 3]) rotate([0, 0, 120]) linear_extrude(height = 17) polygon([[-42, -19.69], [42, -19.69], [42, 19.69], [-42, 19.69]]); translate([-54, 0, 3]) rotate([0, 0, 180]) linear_extrude(height = 17) polygon([[-42, -19.69], [42, -19.69], [42, 19.69], [-42, 19.69]]); translate([-27, -46.7654, 3]) rotate([0, 0, 240]) linear_extrude(height = 17) polygon([[-42, -19.69], [42, -19.69], [42, 19.69], [-42, 19.69]]); translate([27, -46.7654, 3]) rotate([0, 0, 300]) linear_extrude(height = 17) polygon([[-42, -19.69], [42, -19.69], [42, 19.69], [-42, 19.69]]);
  }
  union() {
    translate([0, 0, -1]) rotate([0, 0, 0]) cylinder(d = 17.5, h = 22);
    translate([54, 0, -1]) rotate([0, 0, 0]) cylinder(d = 17.5, h = 22);
  }
}