// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) translate([-40, -30, 0]) cube([80, 60, 3]);
    translate([-20, 10, 3]) difference() { cylinder(d = 36.6, h = 8); translate([0, 0, -0.01]) cylinder(d = 22, h = 8.02); }
    translate([-20, 10, 11]) difference() { cylinder(d = 36.6, h = 28); translate([0, 0, -0.01]) cylinder(d = 30.6, h = 28.02); }
  }
  union() {
    translate([-20, 10, 35.99]) rotate([0, 0, 0]) cylinder(d = 12, h = 3.02);
  }
}