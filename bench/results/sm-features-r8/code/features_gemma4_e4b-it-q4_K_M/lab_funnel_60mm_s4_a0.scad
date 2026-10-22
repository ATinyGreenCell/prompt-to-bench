// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
union() {
    translate([0, 0, 0]) difference() { cylinder(d = 10, h = 20); translate([0, 0, -0.01]) cylinder(d = 6.8, h = 20.02); }
    translate([0, 0, 20]) cylinder(d1 = 10, d2 = 60, h = 30);
  }