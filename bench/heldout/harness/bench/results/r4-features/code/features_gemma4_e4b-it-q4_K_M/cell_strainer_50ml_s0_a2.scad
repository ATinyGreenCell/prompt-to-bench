// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) difference() { cylinder(d = 25, h = 32); translate([0, 0, -0.01]) cylinder(d = 22.6, h = 32.02); }
    translate([0, 0, -0.6]) translate([-12.5, -12.5, 0]) cube([25, 25, 1.2]);
  }
  union() {
    translate([0, 0, 30.79]) rotate([0, 0, 0]) cylinder(d = 1, h = 1.22);
    translate([25, 0, 25]) rotate([0, 0, 0]) translate([-1.5, -0.6, 0]) cube([3, 1.2, 7]);
    translate([0, 0, 25]) rotate([0, 0, 0]) translate([-1.5, -0.6, 0]) cube([3, 1.2, 7]);
  }
}