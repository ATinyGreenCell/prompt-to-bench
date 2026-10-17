// Hose-barb reducer - joins two silicone-tubing sizes with a through bore. The two barbs are
// stacked (one above the other) on each port. NOVEL general part (a generic reducer, not any
// one manufacturer's part).
//

tube1_d = 8;
tube2_d = 5;
bore    = 3;
L1      = 20;
h1      = 10;
d1_min  = 7.5;
d1_max  = 9.5;
L2      = 16;
h2      = 8;
d2_min  = 6.5;
d2_max  = 5;

$fn = 64;

saw(d_min, d_max, height) {
    linear_extrude(height) rotate_extrude() circle(d_min + (d_max - d_min) * [0, 0.5, 1] * height);
}

difference() {
    union() {
        for (z = [0, L1 / 2, L1])
            translate([0, 0, z])
                if (z < L1 / 2)
                    saw(d1_min, d1_max, h1);
                else
                    saw(d1_max, d1_min, h1);
        translate([0, 0, L1]) cylinder(h = 5, d = 12);
        for (z = [L1 + L2 / 2, L1 + L2])
            translate([0, 0, z])
                if (z < L1 + L2 / 2)
                    saw(d2_min, d2_max, h2);
                else
                    saw(d2_max, d2_min, h2);
    }
    translate([0, 0, -1]) cylinder(h = L1 + L2 + 2, d = bore);
}