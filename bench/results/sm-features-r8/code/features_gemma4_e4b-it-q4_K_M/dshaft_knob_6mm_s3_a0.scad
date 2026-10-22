// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
difference() {
  union() {
    translate([0, 0, 0]) cylinder(d = 30, h = 15);
  }
  union() {
    translate([0, 0, 2.99]) rotate([0, 0, 0]) cylinder(d = 6.2, h = 12.02);
    translate([15, 0, 0]) rotate([0, 0, 0]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([14.0954, 5.1303, 0]) rotate([0, 0, 20]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([11.4907, 9.6418, 0]) rotate([0, 0, 40]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([7.5, 12.9904, 0]) rotate([0, 0, 60]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([2.6047, 14.7721, 0]) rotate([0, 0, 80]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-2.6047, 14.7721, 0]) rotate([0, 0, 100]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-7.5, 12.9904, 0]) rotate([0, 0, 120]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-11.4907, 9.6418, 0]) rotate([0, 0, 140]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-14.0954, 5.1303, 0]) rotate([0, 0, 160]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-15, 0, 0]) rotate([0, 0, 180]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-14.0954, -5.1303, 0]) rotate([0, 0, 200]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-11.4907, -9.6418, 0]) rotate([0, 0, 220]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-7.5, -12.9904, 0]) rotate([0, 0, 240]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([-2.6047, -14.7721, 0]) rotate([0, 0, 260]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([2.6047, -14.7721, 0]) rotate([0, 0, 280]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([7.5, -12.9904, 0]) rotate([0, 0, 300]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([11.4907, -9.6418, 0]) rotate([0, 0, 320]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([14.0954, -5.1303, 0]) rotate([0, 0, 340]) translate([-2.35, -15, 0]) cube([4.7, 30, 15]);
    translate([0, 0, 13.99]) rotate([0, 0, 0]) hull() { for (s = [-1, 1]) translate([s * 6.75, 0, 0]) cylinder(d = 1.5, h = 1.02); }
  }
}