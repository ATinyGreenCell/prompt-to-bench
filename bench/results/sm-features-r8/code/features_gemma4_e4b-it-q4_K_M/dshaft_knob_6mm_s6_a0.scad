// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 30, h = 15);
  }
  union() {
    translate([0, 0, 2.99]) rotate([0, 0, 0]) difference() { cylinder(d = 6.2, h = 12.02); translate([-1.6, -6.2, -1]) cube([6.2, 12.4, 14.02]); }
    translate([0, 0, 15]) rotate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 2, h = 1060, center = true);
    translate([0, 0, 15]) rotate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 2, h = 1060, center = true);
    translate([0, 0, 14]) rotate([0, 0, 0]) translate([-15, -0.75, 0]) cube([30, 1.5, 1]);
  }
}