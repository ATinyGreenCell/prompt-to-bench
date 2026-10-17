// Hose-barb reducer - joins two silicone-tubing sizes with a through bore. The two barbs are
// stacked (one above the other) on each port. NOVEL general part (a generic reducer, not any
// one manufacturer's part).
//

tube1_d = 8;
tube2_d = 5;
bore    = 3;
length1 = 20;
length2 = 16;
collar  = 12;

$fn = 64;

saw_teeth = 16;
base_d    = min(tube1_d - 2, tube2_d - 2);         // a base the two barbs share
step      = min(2.5, (tube1_d - base_d) / saw_teeth);
top_d1    = tube1_d - 2;
top_d2    = tube2_d - 2;

difference() {
    union() {
        if (length1 > 0)
            for (z = [0 : length1 / saw_teeth])
                translate([0, 0, z * length1 / saw_teeth])
                    cylinder(h = length1 / saw_teeth, d = base_d + step * saw_teeth);       // lower barb
        if (length2 > 0)
            for (z = [0 : length2 / saw_teeth])
                translate([0, 0, z * length2 / saw_teeth + length1])
                    cylinder(h = length2 / saw_teeth, d = base_d + step * saw_teeth - step);  // upper barb
        if (collar > 0 && length1 > 0)
            translate([0, 0, length1]) cylinder(h = collar, d = min(collar, base_d + step * saw_teeth));
        if (collar > 0 && length2 > 0)
            translate([0, 0, length1 + length2]) cylinder(h = collar, d = min(collar, base_d + step * saw_teeth - step));
    }
    translate([0, 0, -1]) cylinder(h = length1 + length2 + 2, d = bore);
}