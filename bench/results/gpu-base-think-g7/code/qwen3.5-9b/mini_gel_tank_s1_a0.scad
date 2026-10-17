difference() {
            union() {
                cube([120, 70, 40]);
                translate([-30, -32, 3]) cube([60, 64, 10]);
            }
            translate([-57, -32, 3]) cube([114, 64, 37]);
            translate([-60, 0, 30]) cylinder(d=2, h=3, $fn=64);
            translate([60, 0, 30]) cylinder(d=2, h=3, $fn=64);
        }